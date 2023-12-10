part of 'bloc.dart';

enum CommunityInfoStatus { initial, loading, failure, success }

class CreatePostState extends Equatable {
  CreatePostState({
    this.isLoading = false,
    this.communityInfo,
    this.communityInfoStatus = CommunityInfoStatus.initial,
    this.communityId,
    this.exception,
    this.successfullyPostedPost,
    this.isPreviewingBody = false,
    this.url,
    this.image,
    this.editingPostId,
    SplayTreeMap<int, ImageUploadState>? images,
  }) : bodyImages = images ?? SplayTreeMap<int, ImageUploadState>();

  final bool isLoading;
  final LemmyCommunity? communityInfo;
  final int? communityId;
  final MException? exception;
  final CommunityInfoStatus communityInfoStatus;
  final LemmyPost? successfullyPostedPost;
  final bool isPreviewingBody;
  final String? url;

  final ImageUploadState? image;

  /// If the screen is editing a post this would be the id of that post.
  final int? editingPostId;

  final SplayTreeMap<int, ImageUploadState> bodyImages;

  @override
  List<Object?> get props => [
        isLoading,
        communityInfo,
        exception,
        communityInfoStatus,
        communityId,
        successfullyPostedPost,
        isPreviewingBody,
        bodyImages,
        url,
        image,
        editingPostId,
      ];

  CreatePostState copyWith({
    bool? isLoading,
    LemmyCommunity? communityInfo,
    MException? exception,
    CommunityInfoStatus? communityInfoStatus,
    int? communityId,
    LemmyPost? successfullyPosted,
    bool? isPreviewingBody,
    SplayTreeMap<int, ImageUploadState>? images,
    String? url,
    bool setUrlToNull = false,
    ImageUploadState? image,
    bool setImageToNull = false,
    int? editingPostId,
  }) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      communityInfo: communityInfo ?? this.communityInfo,
      exception: exception,
      communityInfoStatus: communityInfoStatus ?? this.communityInfoStatus,
      communityId: communityId ?? this.communityId,
      successfullyPostedPost: successfullyPosted ?? successfullyPostedPost,
      isPreviewingBody: isPreviewingBody ?? this.isPreviewingBody,
      images: images ?? bodyImages,
      url: setUrlToNull ? null : url ?? this.url,
      image: setImageToNull ? null : image ?? this.image,
      editingPostId: editingPostId ?? this.editingPostId,
    );
  }
}

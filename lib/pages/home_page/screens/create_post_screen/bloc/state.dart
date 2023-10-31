part of 'bloc.dart';

enum CommunityInfoStatus { initial, loading, failure, success }

class CreatePostState extends Equatable {
  CreatePostState({
    this.isLoading = false,
    this.communityInfo,
    this.communityInfoStatus = CommunityInfoStatus.initial,
    required this.communityId,
    this.error,
    this.successfullyPostedPost,
    this.isPreviewingBody = false,
    this.url,
    this.image,
    SplayTreeMap<int, ImageUploadState>? images,
  }) : bodyImages = images ?? SplayTreeMap<int, ImageUploadState>();

  final bool isLoading;
  final LemmyCommunity? communityInfo;
  final int communityId;
  final Object? error;
  final CommunityInfoStatus communityInfoStatus;
  final LemmyPost? successfullyPostedPost;
  final bool isPreviewingBody;
  final String? url;

  final ImageUploadState? image;

  final SplayTreeMap<int, ImageUploadState> bodyImages;

  @override
  List<Object?> get props => [
        isLoading,
        communityInfo,
        error,
        communityInfoStatus,
        communityId,
        successfullyPostedPost,
        isPreviewingBody,
        bodyImages,
        url,
        image
      ];

  CreatePostState copyWith({
    bool? isLoading,
    LemmyCommunity? communityInfo,
    Object? error,
    CommunityInfoStatus? communityInfoStatus,
    int? communityId,
    LemmyPost? successfullyPosted,
    bool? isPreviewingBody,
    SplayTreeMap<int, ImageUploadState>? images,
    String? url,
    bool setUrlToNull = false,
    ImageUploadState? image,
    bool setImageToNull = false,
  }) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      communityInfo: communityInfo ?? this.communityInfo,
      error: error,
      communityInfoStatus: communityInfoStatus ?? this.communityInfoStatus,
      communityId: communityId ?? this.communityId,
      successfullyPostedPost: successfullyPosted ?? this.successfullyPostedPost,
      isPreviewingBody: isPreviewingBody ?? this.isPreviewingBody,
      images: images ?? this.bodyImages,
      url: setUrlToNull ? null : url ?? this.url,
      image: setImageToNull ? null : image ?? this.image,
    );
  }
}

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
    SplayTreeMap<int, ImageUploadState>? images,
  }) : images = images ?? SplayTreeMap<int, ImageUploadState>();

  final bool isLoading;
  final LemmyCommunity? communityInfo;
  final int communityId;
  final Object? error;
  final CommunityInfoStatus communityInfoStatus;
  final LemmyPost? successfullyPostedPost;
  final bool isPreviewingBody;

  final SplayTreeMap<int, ImageUploadState> images;

  @override
  List<Object?> get props => [
        isLoading,
        communityInfo,
        error,
        communityInfoStatus,
        communityId,
        successfullyPostedPost,
        isPreviewingBody,
        images,
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
  }) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      communityInfo: communityInfo ?? this.communityInfo,
      error: error,
      communityInfoStatus: communityInfoStatus ?? this.communityInfoStatus,
      communityId: communityId ?? this.communityId,
      successfullyPostedPost: successfullyPosted ?? this.successfullyPostedPost,
      isPreviewingBody: isPreviewingBody ?? this.isPreviewingBody,
      images: images ?? this.images,
    );
  }
}

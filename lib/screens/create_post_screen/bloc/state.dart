part of 'bloc.dart';

enum CommunityInfoStatus { initial, loading, failure, success }

class CreatePostState extends Equatable {
  const CreatePostState({
    this.isLoading = false,
    this.communityInfo,
    this.communityInfoStatus = CommunityInfoStatus.initial,
    required this.communityId,
    this.error,
    this.successfullyPostedPost,
    this.isPreviewingBody = false,
  });

  final bool isLoading;
  final LemmyCommunity? communityInfo;
  final int communityId;
  final Object? error;
  final CommunityInfoStatus communityInfoStatus;
  final LemmyPost? successfullyPostedPost;
  final bool isPreviewingBody;

  @override
  List<Object?> get props => [
        isLoading,
        communityInfo,
        error,
        communityInfoStatus,
        communityId,
        successfullyPostedPost,
        isPreviewingBody,
      ];

  CreatePostState copyWith({
    bool? isLoading,
    LemmyCommunity? communityInfo,
    Object? error,
    CommunityInfoStatus? communityInfoStatus,
    int? communityId,
    LemmyPost? successfullyPosted,
    bool? isPreviewingBody,
  }) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      communityInfo: communityInfo ?? this.communityInfo,
      error: error,
      communityInfoStatus: communityInfoStatus ?? this.communityInfoStatus,
      communityId: communityId ?? this.communityId,
      successfullyPostedPost: successfullyPosted ?? this.successfullyPostedPost,
      isPreviewingBody: isPreviewingBody ?? this.isPreviewingBody,
    );
  }
}

part of 'bloc.dart';

enum CommunityInfoStatus { initial, loading, failure, success }

class CreatePostState extends Equatable {
  const CreatePostState({
    this.isLoading = false,
    this.communityInfo,
    this.communityInfoStatus = CommunityInfoStatus.initial,
    this.error,
  });

  final bool isLoading;
  final LemmyCommunity? communityInfo;
  final Object? error;
  final CommunityInfoStatus communityInfoStatus;

  @override
  List<Object?> get props => [
        isLoading,
        communityInfo,
        error,
        communityInfoStatus,
      ];

  CreatePostState copyWith({
    bool? isLoading,
    LemmyCommunity? communityInfo,
    Object? error,
    CommunityInfoStatus? communityInfoStatus,
  }) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      communityInfo: communityInfo ?? this.communityInfo,
      error: error,
      communityInfoStatus: communityInfoStatus ?? this.communityInfoStatus,
    );
  }
}

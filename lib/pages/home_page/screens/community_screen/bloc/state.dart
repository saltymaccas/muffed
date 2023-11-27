part of 'bloc.dart';

enum CommunityStatus { initial, loading, success, failure }

final class CommunityScreenState extends Equatable {
  ///
  const CommunityScreenState({
    this.communityStatus = CommunityStatus.initial,
    this.community,
    this.sortType = LemmySortType.hot,
    this.errorMessage,
    this.fullCommunityInfoStatus = CommunityStatus.initial,
    this.isLoading = false,
    this.loadedSortType = LemmySortType.hot,
  });

  final LemmyCommunity? community;

  /// The status of the community info
  final CommunityStatus communityStatus;

  /// the status of the community info with moderators and languages
  ///
  /// The reason there are two community info statuses is because
  /// the search screen does not return the moderates and languages
  /// so they will need to be loaded if they are not provided
  final CommunityStatus fullCommunityInfoStatus;

  final LemmySortType sortType;

  final Object? errorMessage;

  final bool isLoading;

  final LemmySortType loadedSortType;

  @override
  List<Object?> get props => [
        community,
        sortType,
        errorMessage,
        fullCommunityInfoStatus,
        isLoading,
        loadedSortType,
      ];

  CommunityScreenState copyWith({
    CommunityStatus? postsStatus,
    CommunityStatus? communityInfoStatus,
    LemmyCommunity? community,
    int? communityId,
    LemmySortType? sortType,
    Object? error,
    CommunityStatus? fullCommunityInfoStatus,
    bool? isLoading,
    LemmySortType? loadedSortType,
  }) {
    return CommunityScreenState(
      community: community ?? this.community,
      sortType: sortType ?? this.sortType,
      errorMessage: error,
      fullCommunityInfoStatus:
          fullCommunityInfoStatus ?? this.fullCommunityInfoStatus,
      isLoading: isLoading ?? this.isLoading,
      loadedSortType: loadedSortType ?? this.loadedSortType,
    );
  }
}

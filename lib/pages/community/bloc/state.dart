part of 'bloc.dart';

enum CommunityStatus { initial, loading, success, failure }

/// Holds the state for displaying a community
final class CommunityScreenState extends Equatable {
  ///
  const CommunityScreenState({
    this.communityStatus = CommunityStatus.initial,
    this.community,
    this.exception,
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

  final MException? exception;

  final bool isLoading;

  final LemmySortType loadedSortType;

  @override
  List<Object?> get props => [
        community,
        exception,
        fullCommunityInfoStatus,
        isLoading,
        loadedSortType,
        communityStatus,
      ];

  CommunityScreenState copyWith({
    CommunityStatus? communityStatus,
    LemmyCommunity? community,
    MException? exception,
    CommunityStatus? fullCommunityInfoStatus,
    bool? isLoading,
    LemmySortType? loadedSortType,
  }) {
    return CommunityScreenState(
      community: community ?? this.community,
      exception: exception,
      fullCommunityInfoStatus:
          fullCommunityInfoStatus ?? this.fullCommunityInfoStatus,
      communityStatus: communityStatus ?? this.communityStatus,
      isLoading: isLoading ?? this.isLoading,
      loadedSortType: loadedSortType ?? this.loadedSortType,
    );
  }
}

part of 'bloc.dart';

enum CommunityStatus { initial, loading, success, failure }

final class CommunityScreenState extends Equatable {
  ///
  const CommunityScreenState({
    this.isLoading = false,
    this.postsStatus = CommunityStatus.initial,
    this.communityInfoStatus = CommunityStatus.initial,
    this.posts = const [],
    this.pagesLoaded = 0,
    this.community,
    this.sortType = LemmySortType.hot,
    this.loadedSortType = LemmySortType.hot,
    this.errorMessage,
    this.isReloading = false,
    this.reachedEnd = false,
    this.fullCommunityInfoStatus = CommunityStatus.initial,
  }) : assert(
          communityInfoStatus == CommunityStatus.success && community != null ||
              communityInfoStatus != CommunityStatus.success &&
                  community == null,
          'If community info status is success then community must not be null',
        );

  final LemmyCommunity? community;
  final List<LemmyPost> posts;
  final int pagesLoaded;

  /// The status of the community posts
  final CommunityStatus postsStatus;

  /// The status of the community info
  final CommunityStatus communityInfoStatus;

  /// the status of the community info with moderators and languages
  ///
  /// The reason there are two community info statuses is because
  /// the search screen does not return the moderates and languages
  /// so they will need to be loaded if they are not provided
  final CommunityStatus fullCommunityInfoStatus;

  final bool isLoading;

  final bool isReloading;

  final LemmySortType sortType;
  final LemmySortType loadedSortType;

  final Object? errorMessage;

  final bool reachedEnd;

  @override
  List<Object?> get props => [
        isLoading,
        community,
        posts,
        pagesLoaded,
        postsStatus,
        communityInfoStatus,
        sortType,
        loadedSortType,
        errorMessage,
        isReloading,
        reachedEnd,
        communityInfoStatus,
      ];

  CommunityScreenState copyWith({
    bool? isLoading,
    CommunityStatus? postsStatus,
    CommunityStatus? communityInfoStatus,
    LemmyCommunity? community,
    List<LemmyPost>? posts,
    int? pagesLoaded,
    int? communityId,
    LemmySortType? sortType,
    LemmySortType? loadedSortType,
    Object? error,
    bool? isReloading,
    bool? reachedEnd,
    CommunityStatus? fullCommunityInfoStatus,
  }) {
    return CommunityScreenState(
      isLoading: isLoading ?? this.isLoading,
      communityInfoStatus: communityInfoStatus ?? this.communityInfoStatus,
      postsStatus: postsStatus ?? this.postsStatus,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
      community: community ?? this.community,
      posts: posts ?? this.posts,
      sortType: sortType ?? this.sortType,
      loadedSortType: loadedSortType ?? this.loadedSortType,
      errorMessage: error,
      isReloading: isReloading ?? this.isReloading,
      reachedEnd: reachedEnd ?? this.reachedEnd,
      fullCommunityInfoStatus:
          fullCommunityInfoStatus ?? this.fullCommunityInfoStatus,
    );
  }
}

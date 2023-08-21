part of 'bloc.dart';

enum CommunityStatus { initial, loading, success, failure }

final class CommunityScreenState extends Equatable {
  ///
  const CommunityScreenState({
    required this.communityId,
    this.isLoading = false,
    this.postsStatus = CommunityStatus.initial,
    this.communityInfoStatus = CommunityStatus.initial,
    this.posts = const [],
    this.pagesLoaded = 0,
    this.communityInfo,
    this.sortType = LemmySortType.hot,
    this.loadedSortType = LemmySortType.hot,
    this.errorMessage,
  });

  final LemmyCommunity? communityInfo;
  final List<LemmyPost> posts;
  final int pagesLoaded;
  final int communityId;

  // Whether the posts have loaded
  final CommunityStatus postsStatus;

  // Whether the community info has loaded
  final CommunityStatus communityInfoStatus;
  final bool isLoading;

  final LemmySortType sortType;
  final LemmySortType loadedSortType;

  final Object? errorMessage;

  @override
  List<Object?> get props => [
        isLoading,
        communityInfo,
        posts,
        communityId,
        pagesLoaded,
        postsStatus,
        communityInfoStatus,
        sortType,
        loadedSortType,
        errorMessage,
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
    Object? errorMessage,
  }) {
    return CommunityScreenState(
      isLoading: isLoading ?? this.isLoading,
      communityInfoStatus: communityInfoStatus ?? this.communityInfoStatus,
      postsStatus: postsStatus ?? this.postsStatus,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
      communityInfo: community ?? this.communityInfo,
      posts: posts ?? this.posts,
      communityId: communityId ?? this.communityId,
      sortType: sortType ?? this.sortType,
      loadedSortType: loadedSortType ?? this.loadedSortType,
      errorMessage: errorMessage,
    );
  }
}

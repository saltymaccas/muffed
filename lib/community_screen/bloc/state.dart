part of 'bloc.dart';

enum CommunityStatus { initial, loading, success, failure }

final class CommunityScreenState extends Equatable {
  final LemmyCommunity? communityInfo;
  final List<LemmyPost> posts;
  final int pagesLoaded;
  final int communityId;
  final CommunityStatus postsStatus;
  final CommunityStatus communityInfoStatus;
  final bool loadingMorePosts;

  CommunityScreenState(
      {this.loadingMorePosts = false,this.postsStatus = CommunityStatus.initial,
      this.communityInfoStatus = CommunityStatus.initial,
      this.posts = const [],
      this.pagesLoaded = 0,
      this.communityInfo,
      required this.communityId});

  @override
  List<Object?> get props => [
    loadingMorePosts,
        communityInfo,
        posts,
        communityId,
        pagesLoaded,
        postsStatus,
        communityInfoStatus
      ];

  CommunityScreenState copyWith({
    bool? loadingMorePosts,
    CommunityStatus? postsStatus,
    CommunityStatus? communityInfoStatus,
    LemmyCommunity? community,
    List<LemmyPost>? posts,
    int? pagesLoaded,
    int? communityId,
  }) {
    return CommunityScreenState(
      loadingMorePosts: loadingMorePosts ?? this.loadingMorePosts,
      communityInfoStatus: communityInfoStatus ?? this.communityInfoStatus,
      postsStatus: postsStatus ?? this.postsStatus,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
      communityInfo: community ?? this.communityInfo,
      posts: posts ?? this.posts,
      communityId: communityId ?? this.communityId,
    );
  }
}

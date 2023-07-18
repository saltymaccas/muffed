part of 'bloc.dart';

final class CommunityScreenState extends Equatable {
  final LemmyCommunity? community;
  final List<LemmyPost> posts;
  final int pagesLoaded;
  final int communityId;

  CommunityScreenState(
      {this.posts = const [],
      this.pagesLoaded = 0,
      this.community,
      required this.communityId});

  @override
  List<Object?> get props => [community, posts, communityId, pagesLoaded];

  CommunityScreenState copyWith({
    LemmyCommunity? community,
    List<LemmyPost>? posts,
    int? pagesLoaded,
    int? communityId,
  }) {
    return CommunityScreenState(
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
      community: community ?? this.community,
      posts: posts ?? this.posts,
      communityId: communityId ?? this.communityId,
    );
  }
}

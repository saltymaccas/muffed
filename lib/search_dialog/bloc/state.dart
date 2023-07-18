part of 'bloc.dart';

final class SearchState extends Equatable {
  final String searchQuery;
  final List<LemmyCommunity> communities;
  final List<LemmyPerson> people;
  final List<LemmyPost> posts;
  final List<LemmyComment> comments;

  SearchState({
    this.searchQuery = '',
    this.comments = const [],
    this.posts = const [],
    this.people = const [],
    this.communities = const [],
  });

  @override
  List<Object?> get props => [searchQuery, communities, people, posts, comments];

  SearchState copyWith({
    String? searchQuery,
    List<LemmyCommunity>? communities,
    List<LemmyPerson>? people,
    List<LemmyPost>? posts,
    List<LemmyComment>? comments,
  }) {
    return SearchState(
      searchQuery: searchQuery ?? this.searchQuery,
      communities: communities ?? this.communities,
      people: people ?? this.people,
      posts: posts ?? this.posts,
      comments: comments ?? this.comments,
    );
  }
}

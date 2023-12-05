import 'package:equatable/equatable.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';

class CommunitySearchRetriever extends ContentRetriever with EquatableMixin {
  CommunitySearchRetriever({
    required this.repo,
    required this.query,
    required this.sortType,
  });

  final ServerRepo repo;
  final String query;
  final LemmySortType sortType;

  @override
  Future<List<LemmyCommunity>> call({required int page}) async {
    final response = await repo.lemmyRepo.search(
      query: query,
      sortType: sortType,
      page: page,
      searchType: LemmySearchType.communities,
    );

    return response.lemmyCommunities!;
  }

  @override
  List<Object?> get props => [
        repo,
        query,
        sortType,
      ];

  CommunitySearchRetriever copyWith({
    ServerRepo? repo,
    String? query,
    LemmySortType? sortType,
  }) {
    return CommunitySearchRetriever(
      repo: repo ?? this.repo,
      query: query ?? this.query,
      sortType: sortType ?? this.sortType,
    );
  }
}

class PersonSearchRetriever extends ContentRetriever with EquatableMixin {
  PersonSearchRetriever({
    required this.repo,
    required this.query,
    required this.sortType,
  });

  final ServerRepo repo;
  final String query;
  final LemmySortType sortType;

  @override
  Future<List<LemmyUser>> call({required int page}) async {
    final response = await repo.lemmyRepo.search(
      query: query,
      sortType: sortType,
      page: page,
      searchType: LemmySearchType.users,
    );

    return response.lemmyPersons!;
  }

  PersonSearchRetriever copyWith({
    ServerRepo? repo,
    String? query,
    LemmySortType? sortType,
  }) {
    return PersonSearchRetriever(
      repo: repo ?? this.repo,
      query: query ?? this.query,
      sortType: sortType ?? this.sortType,
    );
  }

  @override
  List<Object?> get props => [
        repo,
        query,
        sortType,
      ];
}

class PostSearchRetriever extends ContentRetriever with EquatableMixin {
  PostSearchRetriever({
    required this.repo,
    required this.query,
    required this.sortType,
    this.communityId,
  });

  final ServerRepo repo;
  final String query;
  final LemmySortType sortType;
  final int? communityId;

  @override
  Future<List<LemmyPost>> call({required int page}) async {
    final response = await repo.lemmyRepo.search(
      query: query,
      sortType: sortType,
      communityId: communityId,
      searchType: LemmySearchType.posts,
      page: page,
    );

    return response.lemmyPosts!;
  }

  @override
  List<Object?> get props => [
        repo,
        query,
        sortType,
        communityId,
      ];

  PostSearchRetriever copyWith({
    ServerRepo? repo,
    String? query,
    LemmySortType? sortType,
    int? communityId,
    bool setCommunityIdToNull = false,
  }) {
    return PostSearchRetriever(
      repo: repo ?? this.repo,
      query: query ?? this.query,
      sortType: sortType ?? this.sortType,
      communityId:
          setCommunityIdToNull ? null : communityId ?? this.communityId,
    );
  }
}

class CommentSearchRetriever extends ContentRetriever with EquatableMixin {
  CommentSearchRetriever({
    required this.repo,
    required this.query,
    required this.sortType,
    this.communityId,
  });

  final ServerRepo repo;
  final String query;
  final LemmySortType sortType;
  final int? communityId;

  @override
  Future<List<LemmyComment>> call({required int page}) async {
    final response = await repo.lemmyRepo.search(
      query: query,
      sortType: sortType,
      communityId: communityId,
      searchType: LemmySearchType.comments,
      page: page,
    );

    return response.lemmyComments!;
  }

  @override
  List<Object?> get props => [
        repo,
        query,
        sortType,
        communityId,
      ];

  CommentSearchRetriever copyWith({
    ServerRepo? repo,
    String? query,
    LemmySortType? sortType,
    int? communityId,
    bool setCommunityIdToNull = false,
  }) {
    return CommentSearchRetriever(
      repo: repo ?? this.repo,
      query: query ?? this.query,
      sortType: sortType ?? this.sortType,
      communityId:
          setCommunityIdToNull ? null : communityId ?? this.communityId,
    );
  }
}

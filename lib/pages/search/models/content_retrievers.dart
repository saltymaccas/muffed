import 'package:muffed/widgets/content_scroll/content_scroll.dart';

// class CommunitySearchRetriever
//     extends ContentRetrieverDelegate<LemmyCommunity> {
//   const CommunitySearchRetriever({
//     required this.repo,
//     required this.query,
//     required this.sortType,
//   });

//   final ServerRepo repo;
//   final String query;
//   final LemmySortType sortType;

//   @override
//   Future<List<LemmyCommunity>> retrieveContent({required int page}) async {
//     final response = await repo.lemmyRepo.search(
//       query: query,
//       sortType: sortType,
//       page: page,
//       searchType: LemmySearchType.communities,
//     );

//     return response.lemmyCommunities!;
//   }

//   @override
//   List<Object?> get props => [
//         repo,
//         query,
//         sortType,
//       ];

//   CommunitySearchRetriever copyWith({
//     ServerRepo? repo,
//     String? query,
//     LemmySortType? sortType,
//   }) {
//     return CommunitySearchRetriever(
//       repo: repo ?? this.repo,
//       query: query ?? this.query,
//       sortType: sortType ?? this.sortType,
//     );
//   }
// }

// class PersonSearchRetriever extends ContentRetrieverDelegate<LemmyUser> {
//   const PersonSearchRetriever({
//     required this.repo,
//     required this.query,
//     required this.sortType,
//   });

//   final ServerRepo repo;
//   final String query;
//   final LemmySortType sortType;

//   @override
//   Future<List<LemmyUser>> retrieveContent({required int page}) async {
//     final response = await repo.lemmyRepo.search(
//       query: query,
//       sortType: sortType,
//       page: page,
//       searchType: LemmySearchType.users,
//     );

//     return response.lemmyPersons!;
//   }

//   PersonSearchRetriever copyWith({
//     ServerRepo? repo,
//     String? query,
//     LemmySortType? sortType,
//   }) {
//     return PersonSearchRetriever(
//       repo: repo ?? this.repo,
//       query: query ?? this.query,
//       sortType: sortType ?? this.sortType,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         repo,
//         query,
//         sortType,
//       ];
// }

// class PostSearchRetriever extends ContentRetrieverDelegate<LemmyPost> {
//   const PostSearchRetriever({
//     required this.repo,
//     required this.query,
//     required this.sortType,
//     this.communityId,
//   });

//   final ServerRepo repo;
//   final String query;
//   final LemmySortType sortType;
//   final int? communityId;

//   @override
//   Future<List<LemmyPost>> retrieveContent({required int page}) async {
//     final response = await repo.lemmyRepo.search(
//       query: query,
//       sortType: sortType,
//       communityId: communityId,
//       searchType: LemmySearchType.posts,
//       page: page,
//     );

//     return response.lemmyPosts!;
//   }

//   @override
//   List<Object?> get props => [
//         repo,
//         query,
//         sortType,
//         communityId,
//       ];

//   PostSearchRetriever copyWith({
//     ServerRepo? repo,
//     String? query,
//     LemmySortType? sortType,
//     int? communityId,
//     bool setCommunityIdToNull = false,
//   }) {
//     return PostSearchRetriever(
//       repo: repo ?? this.repo,
//       query: query ?? this.query,
//       sortType: sortType ?? this.sortType,
//       communityId:
//           setCommunityIdToNull ? null : communityId ?? this.communityId,
//     );
//   }
// }

// class CommentSearchRetriever extends ContentRetrieverDelegate<LemmyComment> {
//   const CommentSearchRetriever({
//     required this.repo,
//     required this.query,
//     required this.sortType,
//     this.communityId,
//   });

//   final ServerRepo repo;
//   final String query;
//   final LemmySortType sortType;
//   final int? communityId;

//   @override
//   Future<List<LemmyComment>> retrieveContent({required int page}) async {
//     final response = await repo.lemmyRepo.search(
//       query: query,
//       sortType: sortType,
//       communityId: communityId,
//       searchType: LemmySearchType.comments,
//       page: page,
//     );

//     return response.lemmyComments!;
//   }

//   @override
//   List<Object?> get props => [
//         repo,
//         query,
//         sortType,
//         communityId,
//       ];

//   CommentSearchRetriever copyWith({
//     ServerRepo? repo,
//     String? query,
//     LemmySortType? sortType,
//     int? communityId,
//     bool setCommunityIdToNull = false,
//   }) {
//     return CommentSearchRetriever(
//       repo: repo ?? this.repo,
//       query: query ?? this.query,
//       sortType: sortType ?? this.sortType,
//       communityId:
//           setCommunityIdToNull ? null : communityId ?? this.communityId,
//     );
//   }
// }

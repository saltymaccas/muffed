// part of 'bloc.dart';

// final class SearchState extends Equatable {
//   ///
//   const SearchState({
//     this.sortType = LemmySortType.topAll,
//     this.searchQuery = '',
//     this.communityId,
//     this.communityName,
//   });

//   final String? communityName;
//   final int? communityId;

//   final LemmySortType sortType;
//   final String searchQuery;

//   @override
//   List<Object?> get props => [
//         communityId,
//         communityName,
//         sortType,
//         searchQuery,
//       ];

//   SearchState copyWith({
//     LemmySortType? sortType,
//     String? searchQuery,
//     String? communityName,
//     int? communityId,
//     bool setCommunityNameAndIdToNull = false,
//   }) {
//     return SearchState(
//       sortType: sortType ?? this.sortType,
//       searchQuery: searchQuery ?? this.searchQuery,
//       communityName: setCommunityNameAndIdToNull
//           ? null
//           : communityName ?? this.communityName,
//       communityId:
//           setCommunityNameAndIdToNull ? null : communityId ?? this.communityId,
//     );
//   }
// }

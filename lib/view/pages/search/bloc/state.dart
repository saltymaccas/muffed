part of 'bloc.dart';

enum SearchStatus {
  initial,
  loading,
  success,
  failure,
  loadMoreFailure,
  loadingMore,
  reloading,
}

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    required SearchStatus status,
    required String searchQuery,
    required LemmySortType selectedSortType,
    required LemmySearchType searchType,
    required int pagesLoaded,
    List<LemmyPost>? posts,
    List<LemmyComment>? comments,
    List<LemmyCommunity>? communities,
    List<LemmyPerson>? users,
    LemmySortType? loadedSortType,
    String? loadedSearchQuery,
    String? errorMessage,
    int? communityId,
    String? communityName,
  }) = _SearchState;
}

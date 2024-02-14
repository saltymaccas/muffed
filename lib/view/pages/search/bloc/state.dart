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
    required LemmySortType selectedSortType,
    required LemmySearchType searchType,
    required int pagesLoaded,
    required bool allPagesLoaded,
    required String searchQuery,
    List<LemmyPost>? posts,
    List<LemmyComment>? comments,
    List<LemmyCommunity>? communities,
    List<LemmyPerson>? users,
    LemmySortType? loadedSortType,
    String? errorMessage,
    int? communityId,
    String? communityName,
    String? loadedSearchQuery,
  }) = _SearchState;
}

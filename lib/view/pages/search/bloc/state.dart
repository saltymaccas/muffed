part of 'bloc.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    required PagedScrollViewStatus status,
    required int pagesLoaded,
    required SortType sort,
    required String query,
    List<Object>? items,
    String? errorMessage,
  }) = _SearchState;
}

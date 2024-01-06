part of 'bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required bool loading,
    required bool reloading,
    required bool loadingMore,
    required bool loadedAllPages,
    required SortType sort,
    required int pagesLoaded,
    List<PostView>? posts,
    Object? error,
  }) = _HomeState;
}

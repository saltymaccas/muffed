part of 'bloc.dart';

enum HomeStateStatus {
  idle,
  loading,
  reloading,
  loadingMore,
  failure;

  bool get isIdle => this == HomeStateStatus.idle;
  bool get isLoading => this == HomeStateStatus.loading;
  bool get isReloading => this == HomeStateStatus.reloading;
  bool get isLoadingMore => this == HomeStateStatus.loadingMore;
  bool get isFailure => this == HomeStateStatus.failure;
}

@freezed
class LemmyPostScrollState with _$HomeState {
  const factory LemmyPostScrollState({
    required HomeStateStatus status,
    required bool loadedAllPages,
    required SortType selectedSort,
    required SortType loadedSort,
    required int pagesLoaded,
    Object? exception,
    LemmyPostScrollEvent? lastEvent,
    List<PostView>? posts,
  }) = _HomeState;

  const LemmyPostScrollState._();

  bool get hasLoadedContent => posts != null && posts!.isNotEmpty;
}

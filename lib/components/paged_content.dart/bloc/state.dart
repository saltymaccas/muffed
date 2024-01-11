part of 'bloc.dart';

@freezed
class PagedContentState with _$PagedContentState {
  const factory PagedContentState({
    PagedContentLoadingState? loadingState,
    PagedContentLoadedState? loadedState,
  }) = _PagedContentState;

  const PagedContentState._();

  bool get isLoading => loadingState != null;
  bool get isLoaded => loadedState != null;
}

//
//
//

@freezed
class PagedContentLoadingState with _$PagedContentLoadingState {
  const factory PagedContentLoadingState({
    required GetPosts query,
    PagedContentLoadingFailureState? failureState,
  }) = _PagedContentLoadingState;

  const PagedContentLoadingState._();
}

@freezed
class PagedContentLoadingFailureState with _$PagedContentLoadingFailureState {
  const factory PagedContentLoadingFailureState({
    required String message,
  }) = _PagedContentLoadingFailureState;
}

class PagedContentReloadingState extends PagedContentLoadingState {
  PagedContentReloadingState() : super._();
}

class PagedContentLoadingMoreState extends PagedContentLoadingState {
  PagedContentLoadingMoreState() : super._();
}

@freezed
class PagedContentLoadedState with _$PagedContentLoadedState {
  const factory PagedContentLoadedState({
    required List<PostView> content,
    required int loadedPage,
    required GetPosts query,
  }) = _PagedContentLoadedState;
}

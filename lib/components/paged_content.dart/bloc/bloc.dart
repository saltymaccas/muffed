import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:muffed/interfaces/lemmy/lemmy.dart';

part 'state.dart';
part 'event.dart';
part 'bloc.freezed.dart';

class PostPagedScrollBloc extends Bloc<PagedContentEvent, PagedContentState> {
  PostPagedScrollBloc(LemmyClient lemmyClient)
      : lem = lemmyClient,
        super(PagedContentState()) {
    on<LoadNextPageRequested>(_onLoadNextPageRequested);
    on<ReloadRequested>(_onReloadRequested);
    on<LoadNewQueryRequested>(_onLoadNewQueryRequested);
  }

  Future<void> _onLoadNextPageRequested(
    LoadNextPageRequested event,
    Emitter<PagedContentState> emit,
  ) async {
    if (state.loadedState == null) {
      return Future.error('load next page tried when no query was loaded');
    }

    final nextPage = state.loadedState!.loadedPage + 1;

    emit(state.copyWith(loadingState: PagedContentLoadingMoreState()));
    try {
      final posts =
          await lem.run(state.loadedState!.query.copyWith(page: nextPage));
      emit(
        state.copyWith(
          loadedState: PagedContentLoadedState(
            content: [...state.loadedState!.content, ...posts.posts],
            loadedPage: nextPage,
            query: state.loadedState!.query,
          ),
          loadingState: null,
        ),
      );
    } on LemmyApiException catch (e) {
      onLemmyException(e, emit);
    } on DioException catch (e) {
      onDioExcepton(e, emit);
    }
  }

  Future<void> _onReloadRequested(
    ReloadRequested event,
    Emitter<PagedContentState> emit,
  ) async {
    if (state.loadedState == null) {
      return Future.error('reload tried when no query was loaded');
    }

    emit(state.copyWith(loadingState: PagedContentReloadingState()));
    try {
      final posts = await lem.run(state.loadedState!.query.copyWith(page: 1));
      emit(
        state.copyWith(
          loadedState: PagedContentLoadedState(
            content: posts.posts,
            loadedPage: 1,
            query: state.loadedState!.query,
          ),
          loadingState: null,
        ),
      );
    } on LemmyApiException catch (e) {
      onLemmyException(e, emit);
    } on DioException catch (e) {
      onDioExcepton(e, emit);
    }
  }

  Future<void> _onLoadNewQueryRequested(
      LoadNewQueryRequested event, Emitter<PagedContentState> emit) async {
    emit(
      state.copyWith(
        loadingState: PagedContentLoadingState(
          query:  event.query,

        ),
      ),
    );

    try {
      final posts = await lem.run(event.query.copyWith(page: 1));
      emit(
        state.copyWith(
          loadedState: PagedContentLoadedState(
            content: posts.posts,
            loadedPage: 1,
            query: event.query,
          ),
          loadingState: null,
        ),
      );
    } on LemmyApiException catch (e) {
      onLemmyException(e, emit);
    } on DioException catch (e) {
      onDioExcepton(e, emit);
    }
  }

  void onDioExcepton(DioException e, Emitter<PagedContentState> emit) {
    emit(
      state.copyWith(
        loadingState: state.loadingState!.copyWith(
          failureState: PagedContentLoadingFailureState(
            message: "${e.type} ${e.message}",
          ),
        ),
      ),
    );
    emit(state.copyWith(loadingState: null));
  }

  void onLemmyException(LemmyApiException e, Emitter<PagedContentState> emit) {
    emit(
      state.copyWith(
        loadingState: state.loadingState!.copyWith(
          failureState: PagedContentLoadingFailureState(
            message: "${e.message}",
          ),
        ),
      ),
    );
    emit(state.copyWith(loadingState: null));
  }

  final LemmyClient lem;
}

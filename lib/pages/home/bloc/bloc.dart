import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:logging/logging.dart';
import 'package:muffed/exception/models/models.dart';
import 'package:muffed/interfaces/lemmy/lemmy.dart';

part 'event.dart';
part 'state.dart';

part 'bloc.freezed.dart';

final _log = Logger('HomeBloc');

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.lem})
      : super(
          const HomeState(
            sort: SortType.hot,
            loadedAllPages: false,
            loading: false,
            loadingMore: false,
            reloading: false,
            pagesLoaded: 0,
          ),
        ) {
    on<HomeCreated>(_loadInitial, transformer: restartable());
    on<RetriedFromError>(_loadInitial, transformer: restartable());
    on<SortChanged>(
      _onSortChanged,
      transformer: restartable(),
    );
    on<ReachedNearScrollEnd>(
      _onReachedNearScrollEnd,
      transformer: droppable(),
    );
    on<PullDownReload>(_onPullDownReload, transformer: droppable());
  }

  Future<void> _loadInitial(HomeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final response = await _getPosts(page: initialPage);
      emit(
        state.copyWith(
          loading: false,
          posts: response.posts,
          pagesLoaded: initialPage,
        ),
      );
    } catch (error, stackTrace) {
      _log.warning('Error while loading initial posts', error, stackTrace);
      emit(state.copyWith(error: error, loading: false));
    }
  }

  Future<void> _onSortChanged(
    SortChanged event,
    Emitter<HomeState> emit,
  ) async {
    final lastSort = state.sort;
    emit(
      state.copyWith(
        sort: event.sort,
        loading:  true,
        error: null,
      ),
    );
    try {
      final response = await _getPosts(page: initialPage, sort: event.sort);
      emit(
        state.copyWith(
          loading: false,
          posts: response.posts,
          pagesLoaded: initialPage,
        ),
      );
    } catch (error, stackTrace) {
      _log.warning('Error while loading initial posts', error, stackTrace);
      emit(state.copyWith(
          sort: lastSort, loading: false, error: error));
    }
  }

  Future<void> _onReachedNearScrollEnd(
    ReachedNearScrollEnd event,
    Emitter<HomeState> emit,
  ) async {
    if (state.loadedAllPages) return;

    emit(state.copyWith(loadingMore: true, error: null));
    try {
      final response = await _getPosts(page: nextPage);
      emit(
        state.copyWith(
          loadingMore: true,
          posts: [...state.posts ?? [], ...response.posts],
          pagesLoaded: nextPage,
          loadedAllPages: response.posts.isEmpty,
        ),
      );
    } catch (error, stackTrace) {
      _log.warning('Error while loading more posts', error, stackTrace);
      emit(state.copyWith(error: error, loadingMore: false));
    }
  }

  Future<void> _onPullDownReload(
    PullDownReload event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(reloading: true, error: null));
    try {
      final response = await _getPosts(page: initialPage);
      emit(
        state.copyWith(
          reloading: false,
          posts: response.posts,
          pagesLoaded: initialPage,
        ),
      );
    } catch (error, stackTrace) {
      _log.warning('Error while loading initial posts', error, stackTrace);
      emit(state.copyWith(error: error, reloading: false));
    }
  }

  Future<GetPostsResponse> _getPosts({required int page, SortType? sort}) =>
      lem.getPosts(
        sort: sort ?? state.sort,
        page: page,
      );

  int get initialPage => 1;
  int get nextPage => state.pagesLoaded + 1;

  final LemmyClient lem;
}

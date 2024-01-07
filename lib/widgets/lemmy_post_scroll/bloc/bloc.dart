import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:logging/logging.dart';
import 'package:muffed/exception/models/models.dart';
import 'package:muffed/interfaces/lemmy/lemmy.dart';
import 'package:muffed/widgets/post/post.dart';

part 'event.dart';
part 'state.dart';

part 'bloc.freezed.dart';

final _log = Logger('HomeBloc');

class LemmyPostScrollBloc
    extends Bloc<LemmyPostScrollEvent, LemmyPostScrollState> {
  LemmyPostScrollBloc({required this.lem,required SortType initialSort})
      : super(
          LemmyPostScrollState(
            selectedSort: initialSort,
            loadedSort: initialSort,
            loadedAllPages: false,
            pagesLoaded: 0,
            status: HomeStateStatus.idle,
          ),
        ) {
    on<HomeCreated>(_homeCreated, transformer: restartable());
    on<SortChanged>(
      _onSortChanged,
      transformer: restartable(),
    );
    on<ReachedNearScrollEnd>(
      _onReachedNearScrollEnd,
      transformer: droppable(),
    );
    on<PullDownReload>(_onPullDownReload, transformer: droppable());
    on<Retry>((event, emit) => add(state.lastEvent!));
  }

  Future<void> _homeCreated(
      LemmyPostScrollEvent event, Emitter<LemmyPostScrollState> emit) async {
    emit(
      state.copyWith(
        status: HomeStateStatus.loading,
        lastEvent: event,
      ),
    );
    try {
      final response = await _getPosts(page: initialPage);
      emit(
        state.copyWith(
          status: HomeStateStatus.idle,
          posts: response.posts,
          pagesLoaded: initialPage,
          loadedSort: state.selectedSort,
        ),
      );
    } catch (error, stackTrace) {
      _log.warning('Error while loading initial posts', error, stackTrace);
      emit(
        state.copyWith(
          status: HomeStateStatus.failure,
          exception: error,
        ),
      );
    }
  }

  Future<void> _onSortChanged(
    SortChanged event,
    Emitter<LemmyPostScrollState> emit,
  ) async {
    emit(
      state.copyWith(
          selectedSort: event.sort,
          status: HomeStateStatus.loading,
          lastEvent: event),
    );
    try {
      final response =
          await _getPosts(page: initialPage, sort: state.selectedSort);
      emit(
        state.copyWith(
          status: HomeStateStatus.idle,
          posts: response.posts,
          pagesLoaded: initialPage,
          loadedSort: state.selectedSort,
        ),
      );
    } catch (error, stackTrace) {
      _log.warning('Error while loading initial posts', error, stackTrace);
      emit(
        state.copyWith(
          selectedSort: state.loadedSort,
          status: HomeStateStatus.failure,
          exception: error,
        ),
      );
    }
  }

  Future<void> _onReachedNearScrollEnd(
    ReachedNearScrollEnd event,
    Emitter<LemmyPostScrollState> emit,
  ) async {
    if (state.loadedAllPages) return;
    if (state.status.isFailure && state.lastEvent is ReachedNearScrollEnd) {
      return;
    }

    emit(state.copyWith(status: HomeStateStatus.loadingMore, lastEvent: event));
    try {
      final response = await _getPosts(page: nextPage);
      emit(
        state.copyWith(
          posts: [...state.posts ?? [], ...response.posts],
          pagesLoaded: nextPage,
          loadedAllPages: response.posts.isEmpty,
          status: HomeStateStatus.idle,
        ),
      );
    } catch (error, stackTrace) {
      _log.warning('Error while loading more posts', error, stackTrace);
      emit(
        state.copyWith(
          exception: error,
          status: HomeStateStatus.failure,
        ),
      );
    }
  }

  Future<void> _onPullDownReload(
    PullDownReload event,
    Emitter<LemmyPostScrollState> emit,
  ) async {
    emit(
      state.copyWith(
        status: HomeStateStatus.reloading,
        lastEvent: event,
      ),
    );
    try {
      final response = await _getPosts(page: initialPage);
      emit(
        state.copyWith(
          status: HomeStateStatus.idle,
          posts: response.posts,
          pagesLoaded: initialPage,
        ),
      );
    } catch (error, stackTrace) {
      _log.warning('Error while loading initial posts', error, stackTrace);
      emit(state.copyWith(exception: error, status: HomeStateStatus.failure));
    }
  }

  Future<GetPostsResponse> _getPosts({required int page, SortType? sort}) =>
      lem.getPosts(
        sort: sort ?? state.selectedSort,
        page: page,
      );

  int get initialPage => 1;
  int get nextPage => state.pagesLoaded + 1;

  final LemmyClient lem;
}

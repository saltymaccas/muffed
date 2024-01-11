import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:logging/logging.dart';
import 'package:muffed/interfaces/lemmy/lemmy.dart';

part 'event.dart';
part 'state.dart';

part 'bloc.freezed.dart';

final _log = Logger('HomeBloc');

class LemmyPostScrollBloc
    extends Bloc<LemmyPostScrollEvent, LemmyPostScrollState> {
  LemmyPostScrollBloc({
    required this.lem,
    required ListingType listingType, required SortType sortType, required,
  }) : super(
          LemmyPostScrollState(
            selectedQuery: GetPosts(
              type: listingType,
              sort: sortType,
            ),
            loadedQuery: null,
            allPagesLoaded: false,
            pagesLoaded: 0,
            status: HomeStateStatus.idle,
          ),
        ) {
    on<Initialised>(_initialised, transformer: restartable());
    on<QueryChanged>(
      _onQueryChanged,
      transformer: restartable(),
    );
    on<ReachedNearScrollEnd>(
      _onReachedNearScrollEnd,
      transformer: droppable(),
    );
    on<PullDownReload>(_onPullDownReload, transformer: droppable());
    on<Retry>((event, emit) => add(state.lastEvent!));
  }

  Future<void> _initialised(
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
          loadedQuery: state.selectedQuery,
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

  Future<void> _onQueryChanged(
    QueryChanged event,
    Emitter<LemmyPostScrollState> emit,
  ) async {
    final lastSelectedQuery = state.selectedQuery;
    emit(
      state.copyWith(
        selectedQuery: event.query,
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
          loadedQuery: event.query,
        ),
      );
    } catch (error, stackTrace) {
      _log.warning('Error while loading initial posts', error, stackTrace);
      emit(
        state.copyWith(
          selectedQuery: state.loadedQuery ?? lastSelectedQuery,
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
    if (state.allPagesLoaded) return;
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
          allPagesLoaded: response.posts.isEmpty,
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
      lem.run(state.selectedQuery.copyWith(page: page));

  int get initialPage => 1;
  int get nextPage => state.pagesLoaded + 1;

  final LemmyClient lem;
}

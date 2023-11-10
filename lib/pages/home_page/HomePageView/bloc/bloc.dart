import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/pages/home_page/HomePageView/home_page_view.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('HomePageBloc');

/// The bloc that controls the home page
class HomeViewPageBloc extends Bloc<HomePageViewEvent, HomePageViewState> {
  ///
  HomeViewPageBloc({required ServerRepo repo, required this.mode})
      : _repo = repo,
        super(const HomePageViewState(status: HomePageStatus.initial)) {
    on<LoadInitialPostsRequested>((event, emit) async {
      emit(const HomePageViewState(status: HomePageStatus.loading));

      _log.info('Loading initial posts');

      try {
        final List<LemmyPost> posts = await _repo.lemmyRepo.getPosts(
          listingType: mode.listingType,
          page: 1,
          sortType: state.sortType,
        );
        emit(
          HomePageViewState(
            status: HomePageStatus.success,
            posts: posts,
            pagesLoaded: 1,
          ),
        );
      } catch (err) {
        _log.shout('Loading initial posts failed', err);
        emit(
          HomePageViewState(
            status: HomePageStatus.failure,
            errorMessage: err.toString(),
          ),
        );
      }
    });
    on<PullDownRefresh>((event, emit) async {
      emit(state.copyWith(isRefreshing: true));

      final List<LemmyPost> posts = await _repo.lemmyRepo.getPosts(
        listingType: mode.listingType,
        page: 1,
        sortType: state.sortType,
      );

      emit(state.copyWith(posts: posts, isRefreshing: false, pagesLoaded: 1));
    });
    on<ReachedNearEndOfScroll>(
      (event, emit) async {
        if (!state.reachedEnd) {
          _log.info('Loading page ${state.pagesLoaded + 1}');
          emit(state.copyWith(isLoading: true));

          final List<LemmyPost> posts = await _repo.lemmyRepo.getPosts(
            listingType: mode.listingType,
            page: state.pagesLoaded + 1,
            sortType: state.sortType,
          );

          if (posts.isEmpty) {
            emit(state.copyWith(isLoading: false, reachedEnd: true));
          } else {
            emit(
              state.copyWith(
                posts: {...state.posts!, ...posts}.toList(),
                pagesLoaded: state.pagesLoaded + 1,
                isLoading: false,
              ),
            );
          }

          _log.info('Loaded page ${state.pagesLoaded}');
        }
      },
      transformer: droppable(),
    );
    on<AccountChanged>(
      (event, emit) async {
        emit(state.copyWith(posts: [], pagesLoaded: 0));
        try {
          final List<LemmyPost> posts = await _repo.lemmyRepo.getPosts(
            listingType: mode.listingType,
            page: 1,
            sortType: state.sortType,
          );
          emit(
            HomePageViewState(
              status: HomePageStatus.success,
              posts: posts,
              pagesLoaded: 1,
            ),
          );
        } catch (err) {
          emit(
            HomePageViewState(
              status: HomePageStatus.failure,
              errorMessage: err.toString(),
            ),
          );
        }
      },
      transformer: restartable(),
    );
    on<SortTypeChanged>((event, emit) async {
      // Saves last listing type so it can be reverted if error occurs
      final LemmySortType lastSortType = state.sortType;

      emit(state.copyWith(sortType: event.sortType, isLoading: true));

      try {
        final List<LemmyPost> posts = await _repo.lemmyRepo.getPosts(
          listingType: mode.listingType,
          sortType: state.sortType,
          page: 1,
        );
        emit(
          state.copyWith(
            posts: posts,
            isLoading: false,
            pagesLoaded: 1,
            loadedSortType: event.sortType,
          ),
        );
      } catch (err) {
        emit(
          state.copyWith(
            isLoading: false,
            sortType: lastSortType,
            errorMessage: err.toString(),
          ),
        );
        _log.warning(err);
      }
    });
  }

  final ServerRepo _repo;
  final HomePageViewMode mode;

  @override
  void onChange(Change<HomePageViewState> change) {
    super.onChange(change);
    _log.fine(change);
  }

  @override
  void onTransition(
      Transition<HomePageViewEvent, HomePageViewState> transition) {
    super.onTransition(transition);
    _log.fine(transition);
  }
}

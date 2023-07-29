import 'dart:developer';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  ///
  HomePageBloc({required this.repo})
      : super(HomePageState(status: HomePageStatus.initial)) {
    on<LoadInitialPostsRequested>((event, emit) async {
      emit(HomePageState(status: HomePageStatus.loading));

      try {
        List<LemmyPost> posts = await repo.lemmyRepo.getPosts(page: 1);
        emit(
          HomePageState(
            status: HomePageStatus.success,
            posts: posts,
            pagesLoaded: 1,
          ),
        );
      } catch (err) {
        emit(
          HomePageState(
            status: HomePageStatus.failure,
            errorMessage: err.toString(),
          ),
        );
      }
    });
    on<PullDownRefresh>((event, emit) async {
      emit(state.copyWith(isRefreshing: true));

      final List<LemmyPost> posts = await repo.lemmyRepo.getPosts();

      emit(state.copyWith(posts: posts, isRefreshing: false, pagesLoaded: 1));
    });
    on<ReachedNearEndOfScroll>(
      (event, emit) async {
        log('[HomePageBloc] Loading page ${state.pagesLoaded + 1}');
        emit(state.copyWith(isLoadingMore: true));

        final List<LemmyPost> posts =
            await repo.lemmyRepo.getPosts(page: state.pagesLoaded + 1);

        emit(
          state.copyWith(
            posts: (state.posts! + posts),
            pagesLoaded: state.pagesLoaded + 1,
            isLoadingMore: false,
          ),
        );

        log('[HomePageBloc] Loaded page ${state.pagesLoaded}');
      },
      transformer: droppable(),
    );
    on<AccountChanged>(
      (event, emit) async {
        emit(state.copyWith(posts: [], pagesLoaded: 0));
        try {
          final List<LemmyPost> posts = await repo.lemmyRepo.getPosts(page: 1);
          emit(
            HomePageState(
              status: HomePageStatus.success,
              posts: posts,
              pagesLoaded: 1,
            ),
          );
        } catch (err) {
          emit(
            HomePageState(
              status: HomePageStatus.failure,
              errorMessage: err.toString(),
            ),
          );
        }
      },
      transformer: restartable(),
    );
  }

  final ServerRepo repo;
}

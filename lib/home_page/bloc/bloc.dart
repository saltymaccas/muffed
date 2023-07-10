import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'event.dart';
part 'state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc({required this.api})
      : super(HomePageState(status: HomePageStatus.initial)) {
    on<LoadInitialPostsRequested>((event, emit) async {
      emit(HomePageState(status: HomePageStatus.loading));

      List posts = await api.getPosts(page: 1);

      emit(HomePageState(status: HomePageStatus.success, posts: posts));
    });
    on<PullDownRefresh>((event, emit) async {
      emit(state.copyWith(isRefreshing: true));

      List posts = await api.getPosts();

      emit(state.copyWith(posts: posts, isRefreshing: false, pagesLoaded: 1));
    });
    on<ReachedNearEndOfScroll>((event, emit) async {
      log('[HomePageBloc] Loading page ${state.pagesLoaded + 1}');
      emit(state.copyWith(isLoadingMore: true));

      List posts = await api.getPosts(page: state.pagesLoaded + 1);

      emit(state.copyWith(
        posts: (state.posts! + posts),
        pagesLoaded: state.pagesLoaded + 1,
        isLoadingMore: false,
      ));

      log('[HomePageBloc] Loaded page ${state.pagesLoaded}');


    }, transformer: droppable());
  }

  final ServerRepo api;
}

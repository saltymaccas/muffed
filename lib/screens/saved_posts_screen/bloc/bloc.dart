import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

class SavedPostsBloc extends Bloc<SavedPostsEvent, SavedPostsState> {
  ///
  SavedPostsBloc({required this.repo}) : super(SavedPostsState()) {
    on<Initialize>((event, emit) async {
      emit(state.copyWith(status: SavedPostsStatus.loading));
      final result = await repo.lemmyRepo.getPosts(
        sortType: state.sortType,
        savedOnly: true,
        page: 1,
      );

      emit(
        state.copyWith(
          posts: result,
          pagesLoaded: 1,
          status: SavedPostsStatus.success,
        ),
      );
      try {} catch (err) {
        emit(state.copyWith(status: SavedPostsStatus.failure, error: err));
      }
    });
    on<ReachedNearEndOfScroll>(
      (event, emit) async {
        if (!state.reachedEnd) {
          emit(
            state.copyWith(
              isLoading: true,
            ),
          );

          try {
            final result = await repo.lemmyRepo.getPosts(
              page: state.pagesLoaded + 1,
              savedOnly: true,
              sortType: state.sortType,
            );

            if (result.isEmpty) {
              emit(state.copyWith(isLoading: false, reachedEnd: true));
            } else {
              emit(
                state.copyWith(
                  posts: {...state.posts, ...result}.toList(),
                  isLoading: false,
                  pagesLoaded: state.pagesLoaded + 1,
                ),
              );
            }
          } catch (err) {
            emit(state.copyWith(isLoading: false, error: err));
          }
        }
      },
      transformer: droppable(),
    );
  }

  final ServerRepo repo;
}

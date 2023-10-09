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

      emit(state.copyWith(posts: result, pagesLoaded: 1));
      try {} catch (err) {
        emit(state.copyWith(status: SavedPostsStatus.failure, error: err));
      }
    });
  }

  final ServerRepo repo;
}

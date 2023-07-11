import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'event.dart';

part 'state.dart';

class ContentScreenBloc extends Bloc<ContentScreenEvent, ContentScreenState> {
  ContentScreenBloc({required this.repo, required this.postId})
      : super(ContentScreenState(status: ContentScreenStatus.initial)) {
    on<InitializeEvent>((event, emit) async {
      List<LemmyComment> comments =
          await repo.lemmyRepo.getComments(postId, page: 1);

      emit(ContentScreenState(
          status: ContentScreenStatus.success,
          comments: comments,
          pagesLoaded: 1));
    });
    on<ReachedNearEndOfScroll>(
      (event, emit) async {
        emit(state.copyWith(isLoadingMore: true));

        List<LemmyComment> comments = await repo.lemmyRepo
            .getComments(postId, page: state.pagesLoaded + 1);

        emit(state.copyWith(
            isLoadingMore: false,
            comments: [...state.comments ?? [], ...comments]));
      },
      transformer: droppable(),
    );
  }

  final ServerRepo repo;
  final int postId;
}

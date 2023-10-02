import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

class CommentItemBloc extends Bloc<CommentItemEvent, CommentItemState> {
  ///
  CommentItemBloc({
    required this.comment,
    required this.children,
    required this.repo,
  }) : super(
          CommentItemState(
            comment: comment,
            children: children,
          ),
        ) {
    on<LoadChildrenRequested>((event, emit) async {
      emit(state.copyWith(loadingChildren: true));

      try {
        final response = await repo.lemmyRepo.getComments(
          postId: comment.postId,
          parentId: comment.id,
          sortType: event.sortType,
        );

        emit(state.copyWith(children: response, loadingChildren: false));
      } catch (err) {
        emit(state.copyWith(error: err, loadingChildren: false));
      }
    });
  }

  final LemmyComment comment;
  final List<LemmyComment> children;
  final ServerRepo repo;
}

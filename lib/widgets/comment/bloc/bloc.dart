import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/db/db.dart';
import 'package:muffed/interfaces/lemmy/lemmy.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('CommentBloc');

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  ///
  CommentBloc({
    required CommentView comment,
    required List<CommentView> children,
    required CommentSortType sortType,
    required this.lemmy,
    required this.globalBloc,
  }) : super(
          CommentState(
            comment: comment,
            children: children,
            sortType: sortType,
          ),
        ) {
    on<LoadChildrenRequested>((event, emit) async {
      emit(state.copyWith(loadingChildren: true));

      try {
        final response = await lemmy.getComments(
          postId: state.comment.comment.postId,
          parentId: state.comment.comment.postId,
          sort: state.sortType,
        );

        emit(state.copyWith(
            children: response.comments, loadingChildren: false));
      } catch (exc, stackTrace) {
        final exception = MException(exc, stackTrace)..log(_log);
        emit(state.copyWith(error: exception, loadingChildren: false));
      }
    });
    on<UpvotePressed>(
      (event, emit) {
        if (globalBloc.state.auth.lemmy.loggedIn) {
          if (globalBloc.state.auth.lemmy.loggedIn) {
            final lastVote = state.comment.myVote;
            final lastDownVoteCount = state.comment.counts.downvotes;
            final lastUpVoteCount = state.comment.counts.downvotes;

            late final int newVote;
            late final int newDownVoteCount;
            late final int newUpVoteCount;

            switch (state.comment.myVote) {
              case 0:
                newVote = 1;
                newDownVoteCount = lastDownVoteCount;
                newUpVoteCount = lastUpVoteCount + 1;
              case 1:
                newVote = 0;
                newDownVoteCount = lastDownVoteCount;
                newUpVoteCount = lastUpVoteCount - 1;
              case -1:
                newVote = 1;
                newDownVoteCount = lastDownVoteCount - 1;
                newUpVoteCount = lastUpVoteCount + 1;
            }

            emit(
              state.copyWith(
                comment: state.comment.copyWith(
                  myVote: newVote,
                  counts: state.comment.counts.copyWith(
                    downvotes: newDownVoteCount,
                    upvotes: newUpVoteCount,
                  ),
                ),
              ),
            );
            try {
              lemmy.createCommentLike(
                commentId: state.comment.comment.id,
                score: newVote,
              );
            } catch (exc, stackTrace) {
              final exception = MException(exc, stackTrace)..log(_log);
              emit(
                state.copyWith(
                  comment: state.comment.copyWith(
                    myVote: lastVote,
                    counts: state.comment.counts.copyWith(
                      downvotes: lastDownVoteCount,
                      upvotes: lastUpVoteCount,
                    ),
                  ),
                  error: exception,
                ),
              );
            }
          }
        }
      },
      transformer: droppable(),
    );
    on<DownvotePressed>(
      (event, emit) {
        if (globalBloc.state.auth.lemmy.loggedIn) {
          final lastVote = state.comment.myVote;
          final lastDownVoteCount = state.comment.counts.downvotes;
          final lastUpVoteCount = state.comment.counts.downvotes;

          late final int newVote;
          late final int newDownVoteCount;
          late final int newUpVoteCount;

          switch (state.comment.myVote) {
            case 0:
              newVote = -1;
              newDownVoteCount = lastDownVoteCount + 1;
              newUpVoteCount = lastUpVoteCount;
            case 1:
              newVote = -1;
              newDownVoteCount = lastDownVoteCount + 1;
              newUpVoteCount = lastUpVoteCount - 1;
            case -1:
              newVote = 0;
              newDownVoteCount = lastDownVoteCount - 1;
              newUpVoteCount = lastUpVoteCount;
          }

          emit(
            state.copyWith(
              comment: state.comment.copyWith(
                counts: state.comment.counts.copyWith(
                  downvotes: newDownVoteCount,
                  upvotes: newUpVoteCount,
                ),
                myVote: newVote,
              ),
            ),
          );
          try {
            lemmy.createCommentLike(
                commentId: state.comment.comment.id, score: newVote);
          } catch (exc, stackTrace) {
            final exception = MException(exc, stackTrace)..log(_log);
            emit(
              state.copyWith(
                comment: state.comment.copyWith(
                  myVote: lastVote,
                  counts: state.comment.counts.copyWith(
                    downvotes: lastDownVoteCount,
                    upvotes: lastUpVoteCount,
                  ),
                ),
                error: exception,
              ),
            );
          }
        }
      },
      transformer: droppable(),
    );
  }

  final LemmyClient lemmy;
  final DB globalBloc;
}

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('CommentBloc');

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  ///
  CommentBloc({
    required LemmyComment comment,
    required List<LemmyComment> children,
    required LemmyCommentSortType sortType,
    required this.repo,
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
        final response = await repo.lemmyRepo.getComments(
          postId: comment.postId,
          parentId: comment.id,
          sortType: state.sortType,
        );

        emit(state.copyWith(children: response, loadingChildren: false));
      } catch (exc, stackTrace) {
        final exception = MException(exc, stackTrace)..log(_log);
        emit(state.copyWith(error: exception, loadingChildren: false));
      }
    });
    on<UpvotePressed>(
      (event, emit) {
        if (globalBloc.state.isLoggedIn) {
          switch (state.comment.myVote) {
            case (LemmyVoteType.none):
              emit(
                state.copyWith(
                  comment: state.comment.copyWith(
                    myVote: LemmyVoteType.upVote,
                    upVotes: state.comment.upVotes + 1,
                  ),
                ),
              );
              try {
                repo.lemmyRepo
                    .voteComment(state.comment.id, LemmyVoteType.upVote);
              } catch (exc, stackTrace) {
                final exception = MException(exc, stackTrace)..log(_log);
                emit(
                  state.copyWith(
                    comment: state.comment.copyWith(
                      myVote: LemmyVoteType.none,
                      upVotes: state.comment.upVotes - 1,
                    ),
                    error: exception,
                  ),
                );
              }
            case (LemmyVoteType.upVote):
              emit(
                state.copyWith(
                  comment: state.comment.copyWith(
                    myVote: LemmyVoteType.none,
                    upVotes: state.comment.upVotes - 1,
                  ),
                ),
              );
              try {
                repo.lemmyRepo
                    .voteComment(state.comment.id, LemmyVoteType.none);
              } catch (exc, stackTrace) {
                final exception = MException(exc, stackTrace)..log(_log);
                emit(
                  state.copyWith(
                    comment: state.comment.copyWith(
                      myVote: LemmyVoteType.upVote,
                      score: state.comment.upVotes + 1,
                    ),
                    error: exception,
                  ),
                );
              }
            case (LemmyVoteType.downVote):
              emit(
                state.copyWith(
                  comment: state.comment.copyWith(
                    downVotes: state.comment.downVotes - 1,
                    upVotes: state.comment.upVotes + 1,
                    myVote: LemmyVoteType.upVote,
                  ),
                ),
              );
              try {
                repo.lemmyRepo
                    .voteComment(state.comment.id, LemmyVoteType.upVote);
              } catch (exc, stackTrace) {
                final exception = MException(exc, stackTrace)..log(_log);
                emit(
                  state.copyWith(
                    comment: state.comment.copyWith(
                      myVote: LemmyVoteType.downVote,
                      downVotes: state.comment.downVotes + 1,
                      upVotes: state.comment.upVotes - 1,
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
        if (globalBloc.state.isLoggedIn) {
          switch (state.comment.myVote) {
            case LemmyVoteType.none:
              emit(
                state.copyWith(
                  comment: state.comment.copyWith(
                    downVotes: state.comment.downVotes + 1,
                    myVote: LemmyVoteType.downVote,
                  ),
                ),
              );
              try {
                repo.lemmyRepo
                    .voteComment(state.comment.id, LemmyVoteType.downVote);
              } catch (exc, stackTrace) {
                final exception = MException(exc, stackTrace)..log(_log);
                emit(
                  state.copyWith(
                    comment: state.comment.copyWith(
                      myVote: LemmyVoteType.none,
                      downVotes: state.comment.downVotes - 1,
                    ),
                    error: exception,
                  ),
                );
              }
            case LemmyVoteType.upVote:
              emit(
                state.copyWith(
                  comment: state.comment.copyWith(
                    downVotes: state.comment.downVotes + 1,
                    upVotes: state.comment.upVotes - 1,
                    myVote: LemmyVoteType.downVote,
                  ),
                ),
              );
              try {
                repo.lemmyRepo
                    .voteComment(state.comment.id, LemmyVoteType.downVote);
              } catch (exc, stackTrace) {
                final exception = MException(exc, stackTrace)..log(_log);
                emit(
                  state.copyWith(
                    comment: state.comment.copyWith(
                      upVotes: state.comment.upVotes + 1,
                      downVotes: state.comment.downVotes - 1,
                      myVote: LemmyVoteType.upVote,
                    ),
                    error: exception,
                  ),
                );
              }
            case LemmyVoteType.downVote:
              emit(
                state.copyWith(
                  comment: state.comment.copyWith(
                    myVote: LemmyVoteType.none,
                    downVotes: state.comment.downVotes - 1,
                  ),
                ),
              );
              try {
                repo.lemmyRepo
                    .voteComment(state.comment.id, LemmyVoteType.none);
              } catch (exc, stackTrace) {
                final exception = MException(exc, stackTrace)..log(_log);
                emit(
                  state.copyWith(
                    comment: state.comment.copyWith(
                      downVotes: state.comment.downVotes + 1,
                      myVote: LemmyVoteType.downVote,
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
  }

  final ServerRepo repo;
  final GlobalBloc globalBloc;
}

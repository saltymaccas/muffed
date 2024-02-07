import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/global_state/bloc.dart';
import 'package:muffed/domain/server_repo.dart';

part 'event.dart';
part 'state.dart';

class CommentItemBloc extends Bloc<CommentItemEvent, CommentItemState> {
  ///
  CommentItemBloc(
      {required this.comment,
      required this.children,
      required this.repo,
      required this.globalBloc,})
      : super(
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
    on<UpvotePressed>(
      (event, emit) {
        if (globalBloc.isLoggedIn()) {
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
              } catch (err) {
                emit(
                  state.copyWith(
                    comment: state.comment.copyWith(
                      myVote: LemmyVoteType.none,
                      upVotes: state.comment.upVotes - 1,
                    ),
                    error: err,
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
              } catch (err) {
                emit(
                  state.copyWith(
                    comment: state.comment.copyWith(
                      myVote: LemmyVoteType.upVote,
                      score: state.comment.upVotes + 1,
                    ),
                    error: err,
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
              } catch (err) {
                emit(
                  state.copyWith(
                    comment: state.comment.copyWith(
                      myVote: LemmyVoteType.downVote,
                      downVotes: state.comment.downVotes + 1,
                      upVotes: state.comment.upVotes - 1,
                    ),
                    error: err,
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
        if (globalBloc.isLoggedIn()) {
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
              } catch (err) {
                emit(
                  state.copyWith(
                    comment: state.comment.copyWith(
                      myVote: LemmyVoteType.none,
                      downVotes: state.comment.downVotes - 1,
                    ),
                    error: err,
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
              } catch (err) {
                emit(
                  state.copyWith(
                    comment: state.comment.copyWith(
                      upVotes: state.comment.upVotes + 1,
                      downVotes: state.comment.downVotes - 1,
                      myVote: LemmyVoteType.upVote,
                    ),
                    error: err,
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
              } catch (err) {
                emit(
                  state.copyWith(
                    comment: state.comment.copyWith(
                      downVotes: state.comment.downVotes + 1,
                      myVote: LemmyVoteType.downVote,
                    ),
                    error: err,
                  ),
                );
              }
          }
        }
      },
      transformer: droppable(),
    );
    on<MinimiseToggled>((event, emit) {
      emit(state.copyWith(minimised: !state.minimised));
    });
  }

  final LemmyComment comment;
  final List<LemmyComment> children;
  final ServerRepo repo;
  final GlobalBloc globalBloc;
}

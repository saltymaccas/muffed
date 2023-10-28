import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/repo/server_repo.dart';

import '../../../global_state/bloc.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('PostItemBloc');

class PostItemBloc extends Bloc<PostItemEvent, PostItemState> {
  ///
  PostItemBloc({
    this.post,
    this.postId,
    required this.repo,
    required this.globalBloc,
  }) : super(PostItemState(post: post)) {
    on<Initialize>((event, emit) async {
      if (post != null) {
        emit(state.copyWith(status: PostItemStatus.success, post: post));
      } else if (postId != null) {
        emit(state.copyWith(status: PostItemStatus.loading));
        try {
          final post = await repo.lemmyRepo.getPost(id: postId!);
          emit(state.copyWith(status: PostItemStatus.success, post: post));
        } catch (err) {
          emit(state.copyWith(status: PostItemStatus.failure, error: err));
        }
      } else
        (emit(state.copyWith(
            status: PostItemStatus.failure, error: 'No post or postId given')));
    });
    on<UpvotePressed>(
      (event, emit) {
        if (globalBloc.isLoggedIn() && state.post != null) {
          switch (state.post!.myVote) {
            case (LemmyVoteType.none):
              emit(
                state.copyWith(
                  post: state.post!.copyWith(
                    myVote: LemmyVoteType.upVote,
                    upVotes: state.post!.upVotes + 1,
                  ),
                ),
              );
              try {
                repo.lemmyRepo.votePost(state.post!.id, LemmyVoteType.upVote);
              } catch (err) {
                emit(
                  state.copyWith(
                    post: state.post!.copyWith(
                      myVote: LemmyVoteType.none,
                      upVotes: state.post!.upVotes - 1,
                    ),
                    error: err,
                  ),
                );
              }
            case (LemmyVoteType.upVote):
              emit(
                state.copyWith(
                  post: state.post!.copyWith(
                    myVote: LemmyVoteType.none,
                    upVotes: state.post!.upVotes - 1,
                  ),
                ),
              );
              try {
                repo.lemmyRepo.votePost(state.post!.id, LemmyVoteType.none);
              } catch (err) {
                emit(
                  state.copyWith(
                    post: state.post!.copyWith(
                      myVote: LemmyVoteType.upVote,
                      score: state.post!.upVotes + 1,
                    ),
                    error: err,
                  ),
                );
              }
            case (LemmyVoteType.downVote):
              emit(
                state.copyWith(
                  post: state.post!.copyWith(
                    downVotes: state.post!.downVotes - 1,
                    upVotes: state.post!.upVotes + 1,
                    myVote: LemmyVoteType.upVote,
                  ),
                ),
              );
              try {
                repo.lemmyRepo.votePost(state.post!.id, LemmyVoteType.upVote);
              } catch (err) {
                emit(
                  state.copyWith(
                    post: state.post!.copyWith(
                      myVote: LemmyVoteType.downVote,
                      downVotes: state.post!.downVotes + 1,
                      upVotes: state.post!.upVotes - 1,
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
        if (globalBloc.isLoggedIn() && state.post != null) {
          switch (state.post!.myVote) {
            case LemmyVoteType.none:
              emit(
                state.copyWith(
                  post: state.post!.copyWith(
                    downVotes: state.post!.downVotes + 1,
                    myVote: LemmyVoteType.downVote,
                  ),
                ),
              );
              try {
                repo.lemmyRepo.votePost(state.post!.id, LemmyVoteType.downVote);
              } catch (err) {
                emit(
                  state.copyWith(
                    post: state.post!.copyWith(
                      myVote: LemmyVoteType.none,
                      downVotes: state.post!.downVotes - 1,
                    ),
                    error: err,
                  ),
                );
              }
            case LemmyVoteType.upVote:
              emit(
                state.copyWith(
                  post: state.post!.copyWith(
                    downVotes: state.post!.downVotes + 1,
                    upVotes: state.post!.upVotes - 1,
                    myVote: LemmyVoteType.downVote,
                  ),
                ),
              );
              try {
                repo.lemmyRepo.votePost(state.post!.id, LemmyVoteType.downVote);
              } catch (err) {
                emit(
                  state.copyWith(
                    post: state.post!.copyWith(
                      upVotes: state.post!.upVotes + 1,
                      downVotes: state.post!.downVotes - 1,
                      myVote: LemmyVoteType.upVote,
                    ),
                    error: err,
                  ),
                );
              }
            case LemmyVoteType.downVote:
              emit(
                state.copyWith(
                  post: state.post!.copyWith(
                    myVote: LemmyVoteType.none,
                    downVotes: state.post!.downVotes - 1,
                  ),
                ),
              );
              try {
                repo.lemmyRepo.votePost(state.post!.id, LemmyVoteType.none);
              } catch (err) {
                emit(
                  state.copyWith(
                    post: state.post!.copyWith(
                      downVotes: state.post!.downVotes + 1,
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
    on<SavePostToggled>((event, emit) async {
      emit(state.copyWith(
          post: state.post!.copyWith(saved: !state.post!.saved)));
      try {
        final result = await repo.lemmyRepo
            .savePost(postId: state.post!.id, save: state.post!.saved);
        emit(state.copyWith(post: state.post!.copyWith(saved: result)));
      } catch (err) {
        emit(
          state.copyWith(
            error: err,
            post: state.post!.copyWith(saved: !state.post!.saved),
          ),
        );
      }
    });
  }

  final LemmyPost? post;
  final int? postId;
  final ServerRepo repo;
  final GlobalBloc globalBloc;

  @override
  void onChange(Change<PostItemState> change) {
    super.onChange(change);
    _log.fine(change);
  }

  @override
  void onTransition(Transition<PostItemEvent, PostItemState> transition) {
    super.onTransition(transition);
    _log.fine(transition);
  }
}

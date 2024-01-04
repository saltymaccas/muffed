import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/db/db.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('PostItemBloc');

class PostBloc extends Bloc<PostEvent, PostState> {
  ///
  PostBloc({
    required this.repo,
    required this.globalBloc,
    LemmyPost? post,
    int? postId,
  })  : assert(
          post != null || postId != null,
          'No post provided in PostBloc constructuctor',
        ),
        super(PostState(post: post)) {
    on<Initialize>((event, emit) async {
      if (post != null) {
        emit(state.copyWith(status: PostStatus.success, post: post));
      } else {
        emit(state.copyWith(status: PostStatus.loading));
        try {
          final post = await repo.lemmyRepo.getPost(id: postId!);
          emit(state.copyWith(status: PostStatus.success, post: post));
        } catch (exc, stackTrace) {
          final exception = MException(exc, stackTrace)..log(_log);
          emit(
            state.copyWith(status: PostStatus.failure, exception: exception),
          );
        }
      }
    });
    on<UpvotePressed>(
      (event, emit) {
        if (globalBloc.state.auth.lemmy.loggedIn && state.post != null) {
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
              } catch (exc, stackTrace) {
                final exception = MException(exc, stackTrace)..log(_log);
                emit(
                  state.copyWith(
                    post: state.post!.copyWith(
                      myVote: LemmyVoteType.none,
                      upVotes: state.post!.upVotes - 1,
                    ),
                    exception: exception,
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
              } catch (exc, stackTrace) {
                final exception = MException(exc, stackTrace)..log(_log);
                emit(
                  state.copyWith(
                    post: state.post!.copyWith(
                      myVote: LemmyVoteType.upVote,
                      score: state.post!.upVotes + 1,
                    ),
                    exception: exception,
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
              } catch (exc, stackTrace) {
                final exception = MException(exc, stackTrace)..log(_log);
                emit(
                  state.copyWith(
                    post: state.post!.copyWith(
                      myVote: LemmyVoteType.downVote,
                      downVotes: state.post!.downVotes + 1,
                      upVotes: state.post!.upVotes - 1,
                    ),
                    exception: exception,
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
        if (globalBloc.state.auth.lemmy.loggedIn && state.post != null) {
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
              } catch (exc, stackTrace) {
                final exception = MException(exc, stackTrace)..log(_log);
                emit(
                  state.copyWith(
                    post: state.post!.copyWith(
                      myVote: LemmyVoteType.none,
                      downVotes: state.post!.downVotes - 1,
                    ),
                    exception: exception,
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
              } catch (exc, stackTrace) {
                final exception = MException(exc, stackTrace)..log(_log);
                emit(
                  state.copyWith(
                    post: state.post!.copyWith(
                      upVotes: state.post!.upVotes + 1,
                      downVotes: state.post!.downVotes - 1,
                      myVote: LemmyVoteType.upVote,
                    ),
                    exception: exception,
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
              } catch (exc, stackTrace) {
                final exception = MException(exc, stackTrace)..log(_log);
                emit(
                  state.copyWith(
                    post: state.post!.copyWith(
                      downVotes: state.post!.downVotes + 1,
                      myVote: LemmyVoteType.downVote,
                    ),
                    exception: exception,
                  ),
                );
              }
          }
        }
      },
      transformer: droppable(),
    );
    on<SavePostToggled>((event, emit) async {
      emit(
        state.copyWith(
          post: state.post!.copyWith(saved: !state.post!.saved),
        ),
      );
      try {
        final result = await repo.lemmyRepo
            .savePost(postId: state.post!.id, save: state.post!.saved);
        emit(state.copyWith(post: state.post!.copyWith(saved: result)));
      } catch (exc, stackTrace) {
        final exception = MException(exc, stackTrace)..log(_log);
        emit(
          state.copyWith(
            exception: exception,
            post: state.post!.copyWith(saved: !state.post!.saved),
          ),
        );
      }
    });
  }

  final ServerRepo repo;
  final DB globalBloc;

  @override
  void onChange(Change<PostState> change) {
    super.onChange(change);
    _log.fine(change);
  }

  @override
  void onTransition(Transition<PostEvent, PostState> transition) {
    super.onTransition(transition);
    _log.fine(transition);
  }
}

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/db/db.dart';
import 'package:muffed/interfaces/lemmy/lemmy.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('PostItemBloc');

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({
    required this.lem,
    required this.globalBloc,
    PostView? post,
    int? postId,
  })  : assert(
          post != null || postId != null,
          'No post provided in PostBloc constructuctor',
        ),
        super(PostState(post: post)) {
    on<Created>((event, emit) async {
      if (post != null) {
        emit(state.copyWith(status: PostStatus.success, post: post));
      } else {
        emit(state.copyWith(status: PostStatus.loading));
        try {
          final post = await lem.getPost(id: postId);
          emit(state.copyWith(status: PostStatus.success, post: post.postView));
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
        if (globalBloc.state.auth.lemmy.loggedIn) {
          if (globalBloc.state.auth.lemmy.loggedIn) {
            final lastVote = state.post!.myVote;
            final lastDownVoteCount = state.post!.counts.downvotes;
            final lastUpVoteCount = state.post!.counts.downvotes;

            late final int newVote;
            late final int newDownVoteCount;
            late final int newUpVoteCount;

            switch (state.post!.myVote) {
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
                post: state.post!.copyWith(
                  myVote: newVote,
                  counts: state.post!.counts.copyWith(
                    downvotes: newDownVoteCount,
                    upvotes: newUpVoteCount,
                  ),
                ),
              ),
            );
            try {
              lem.createPostLike(
                postId: state.post!.post.id,
                score: newVote,
              );
            } catch (exc, stackTrace) {
              final exception = MException(exc, stackTrace)..log(_log);
              emit(
                state.copyWith(
                  post: state.post!.copyWith(
                    myVote: lastVote,
                    counts: state.post!.counts.copyWith(
                      downvotes: lastDownVoteCount,
                      upvotes: lastUpVoteCount,
                    ),
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
        if (globalBloc.state.auth.lemmy.loggedIn) {
          final lastVote = state.post!.myVote;
          final lastDownVoteCount = state.post!.counts.downvotes;
          final lastUpVoteCount = state.post!.counts.downvotes;

          late final int newVote;
          late final int newDownVoteCount;
          late final int newUpVoteCount;

          switch (state.post!.myVote) {
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
              post: state.post!.copyWith(
                counts: state.post!.counts.copyWith(
                  downvotes: newDownVoteCount,
                  upvotes: newUpVoteCount,
                ),
                myVote: newVote,
              ),
            ),
          );
          try {
            lem.createCommentLike(
                commentId: state.post!.post.id, score: newVote);
          } catch (exc, stackTrace) {
            final exception = MException(exc, stackTrace)..log(_log);
            emit(
              state.copyWith(
                post: state.post!.copyWith(
                  myVote: lastVote,
                  counts: state.post!.counts.copyWith(
                    downvotes: lastDownVoteCount,
                    upvotes: lastUpVoteCount,
                  ),
                ),
                exception: exception,
              ),
            );
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
        final result = await lem.savePost(
            postId: state.post!.post.id, save: state.post!.saved);
        emit(state.copyWith(post: result.postView));
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

  final LemmyClient lem;
  final DB globalBloc;
}

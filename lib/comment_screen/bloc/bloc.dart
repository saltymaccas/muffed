import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'event.dart';

part 'state.dart';

/// The bloc for the content screen
class CommentScreenBloc extends Bloc<CommentScreenEvent, CommentScreenState> {
  /// Initialize
  CommentScreenBloc({required this.repo, required this.postId})
      : super(CommentScreenState(status: CommentScreenStatus.initial)) {
    on<InitializeEvent>((event, emit) async {
      emit(CommentScreenState(status: CommentScreenStatus.loading));

      try {
        List<LemmyComment> comments =
            await repo.lemmyRepo.getComments(postId, page: 1);

        emit(
          CommentScreenState(
            status: CommentScreenStatus.success,
            comments: comments,
            pagesLoaded: 1,
          ),
        );
      } catch (err) {
        emit(
          state.copyWith(
            status: CommentScreenStatus.failure,
            errorMessage: err.toString(),
          ),
        );
      }
    });
    on<ReachedNearEndOfScroll>(
      (event, emit) async {
        if (!state.reachedEnd) {
          print('[ContentScreenBloc] loading page ${state.pagesLoaded + 1}');

          emit(state.copyWith(isLoadingMore: true));

          List<LemmyComment> comments = await repo.lemmyRepo
              .getComments(postId, page: state.pagesLoaded + 1);

          if (comments.isEmpty) {
            emit(state.copyWith(reachedEnd: true));

            print('[ContentScreenBloc] end reached');
          } else {
            emit(
              state.copyWith(
                isLoadingMore: false,
                pagesLoaded: state.pagesLoaded + 1,
                comments: [...state.comments ?? [], ...comments],
              ),
            );

            print('[ContentScreenBloc] loaded page ${state.pagesLoaded}');
          }
        }
      },
      transformer: droppable(),
    );
    on<UserCommented>((event, emit) async {
      try {
        await repo.lemmyRepo.createComment(event.comment, postId, null);
        event.onSuccess();
      } catch (err) {
        event.onError();
        emit(
          state.copyWith(
            errorMessage: err.toString(),
          ),
        );
      }
    });
    on<UserRepliedToComment>((event, emit) async {
      try {
        await repo.lemmyRepo
            .createComment(event.comment, postId, event.commentId);
        event.onSuccess();
      } catch (err) {
        emit(state.copyWith(errorMessage: err.toString()));
      }
    });
    on<PullDownRefresh>((event, emit) async {
      emit(state.copyWith(isRefreshing: true));

      try {
        final List<LemmyComment> comments =
            await repo.lemmyRepo.getComments(postId, page: 1);

        emit(
          state.copyWith(
            comments: comments,
            isRefreshing: false,
            pagesLoaded: 1,
            reachedEnd: false,
          ),
        );
      } catch (err) {
        emit(state.copyWith(isRefreshing: false, errorMessage: err.toString()));
      }
    });
  }

  final ServerRepo repo;
  final int postId;
}

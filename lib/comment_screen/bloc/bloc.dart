import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'event.dart';

part 'state.dart';

const pageLoadInterval = 5;

/// The bloc for the content screen
class CommentScreenBloc extends Bloc<CommentScreenEvent, CommentScreenState> {
  /// Initialize
  CommentScreenBloc({required this.repo, required this.postId})
      : super(CommentScreenState(status: CommentScreenStatus.initial)) {
    on<InitializeEvent>((event, emit) async {
      emit(CommentScreenState(status: CommentScreenStatus.loading));

      try {
        for (int i = 1; i < 5; i++) {
          List<LemmyComment> newComments = await repo.lemmyRepo
              .getComments(postId, page: i, sortType: state.sortType);

          final comments = organiseComments(newComments);

          emit(
            CommentScreenState(
              status: CommentScreenStatus.success,
              comments: comments,
              isLoading: true,
              pagesLoaded: i,
            ),
          );
        }
        emit(state.copyWith(isLoading: false));
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

          emit(state.copyWith(isLoading: true));
          try {
            for (int i = state.pagesLoaded + 1;
                i < state.pagesLoaded + 5;
                i++) {
              final newComments = await repo.lemmyRepo.getComments(
                postId,
                page: state.pagesLoaded + 1,
                sortType: state.sortType,
              );

              if (newComments.isEmpty) {
                emit(state.copyWith(isLoading: false, reachedEnd: true));

                print('[ContentScreenBloc] end reached');
              } else {
                final comments =
                    organiseComments([...state.comments ?? [], ...newComments]);

                emit(
                  state.copyWith(
                    pagesLoaded: state.pagesLoaded + 1,
                    comments: comments,
                  ),
                );

                print('[ContentScreenBloc] loaded page ${state.pagesLoaded}');
              }
            }
            emit(state.copyWith(isLoading: false));
          } catch (err) {
            emit(
                state.copyWith(errorMessage: err.toString(), isLoading: false));
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
        final List<LemmyComment> newComments = await repo.lemmyRepo
            .getComments(postId, page: 1, sortType: state.sortType);

        final comments = organiseComments(newComments);

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
    on<SortTypeChanged>((event, emit) async {
      final lastSortType = state.sortType;

      emit(state.copyWith(sortType: event.sortType, isLoading: true));

      try {
        final newComments = await repo.lemmyRepo
            .getComments(postId, page: 1, sortType: state.sortType);

        final comments = organiseComments(newComments);

        emit(
          state.copyWith(
            comments: comments,
            isLoading: false,
            pagesLoaded: 1,
          ),
        );
      } catch (err) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: err.toString(),
            sortType: lastSortType,
          ),
        );
      }
    });
  }

  final ServerRepo repo;
  final int postId;

  List<LemmyComment> organiseComments(List<LemmyComment> inputComments) {
    List<LemmyComment> comments = inputComments;

    List<LemmyComment> toBeRemoved = [];

    for (final comment in comments) {
      for (final comment2 in comments) {
        if (comment != comment2) {
          bool success = comment.addCommentToTree(comment2);
          if (success) {
            toBeRemoved.add(comment2);
            break;
          }
        }
      }
    }

    for (final comment in toBeRemoved) {
      comments.remove(comment);
    }

    return comments;
  }
}

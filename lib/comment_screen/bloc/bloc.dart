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
        List<LemmyComment> comments = await repo.lemmyRepo
            .getComments(postId, page: 1, sortType: state.sortType);

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
        print('[ContentScreenBloc] loading page ${state.pagesLoaded + 1}');

        emit(state.copyWith(isLoading: true));
        try {
          if (!state.reachedEnd) {
            final comments = await repo.lemmyRepo.getComments(
              postId,
              page: state.pagesLoaded + 1,
              sortType: state.sortType,
            );

            if (comments.isEmpty) {
              emit(state.copyWith(isLoading: false, reachedEnd: true));

              print('[ContentScreenBloc] end reached');
            } else {
              emit(
                state.copyWith(
                  isLoading: false,
                  pagesLoaded: state.pagesLoaded + 1,
                  comments: [...state.comments ?? [], ...comments],
                ),
              );

              print('[ContentScreenBloc] loaded page ${state.pagesLoaded}');
            }
          }
        } catch (err) {
          emit(state.copyWith(errorMessage: err.toString(), isLoading: false));
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
        final List<LemmyComment> comments = await repo.lemmyRepo
            .getComments(postId, page: 1, sortType: state.sortType);

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
        emit(
          state.copyWith(
            isLoading: false,
            comments: newComments,
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
}

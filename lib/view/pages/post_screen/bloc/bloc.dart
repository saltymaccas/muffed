import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/domain/server_repo.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('CommentScreenBloc');

/// The bloc for the content screen
class PostScreenBloc extends Bloc<PostScreenEvent, PostScreenState> {
  /// Initialize
  PostScreenBloc({required this.repo, required this.postId})
      : super(const PostScreenState(status: PostScreenStatus.initial)) {
    on<InitializeEvent>((event, emit) async {
      emit(const PostScreenState(status: PostScreenStatus.loading));

      try {
        final List<LemmyComment> newComments = await repo.lemmyRepo
            .getComments(postId: postId, page: 1, sortType: state.sortType);

        final comments = newComments;

        emit(
          PostScreenState(
            status: PostScreenStatus.success,
            comments: comments,
            isLoading: false,
            pagesLoaded: 1,
          ),
        );
      } catch (err) {
        emit(
          state.copyWith(
            status: PostScreenStatus.failure,
            error: err,
          ),
        );
      }
    });
    on<ReachedNearEndOfScroll>(
      (event, emit) async {
        if (!state.reachedEnd && state.status != PostScreenStatus.loading) {
          _log.info('loading page ${state.pagesLoaded + 1}');

          emit(state.copyWith(isLoading: true));
          try {
            final newComments = await repo.lemmyRepo.getComments(
              postId: postId,
              page: state.pagesLoaded + 1,
              sortType: state.sortType,
            );
            final comments = [...state.comments!, ...newComments];

            if (comments.length == state.comments!.length ||
                newComments.isEmpty) {
              emit(state.copyWith(isLoading: false, reachedEnd: true));

              _log.info('Reached end of comments');
            } else {
              emit(
                state.copyWith(
                  pagesLoaded: state.pagesLoaded + 1,
                  comments: comments,
                  isLoading: false,
                  reachedEnd: newComments.isEmpty || newComments.length < 50,
                ),
              );
              _log.info('loaded page ${state.pagesLoaded}');
            }
          } catch (err) {
            emit(
              state.copyWith(error: err, isLoading: false),
            );
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
            error: err,
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
        emit(state.copyWith(error: err));
      }
    });
    on<PullDownRefresh>((event, emit) async {
      emit(state.copyWith(isRefreshing: true));

      try {
        final List<LemmyComment> newComments = await repo.lemmyRepo
            .getComments(postId: postId, page: 1, sortType: state.sortType);

        final comments = newComments;

        emit(
          state.copyWith(
            comments: comments,
            isRefreshing: false,
            pagesLoaded: 1,
            reachedEnd: false,
          ),
        );
      } catch (err) {
        emit(state.copyWith(isRefreshing: false, error: err));
      }
    });
    on<SortTypeChanged>((event, emit) async {
      final lastSortType = state.sortType;

      emit(state.copyWith(sortType: event.sortType, isLoading: true));

      try {
        final newComments = await repo.lemmyRepo
            .getComments(postId: postId, page: 1, sortType: state.sortType);

        final comments = newComments;

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
            error: err,
            sortType: lastSortType,
          ),
        );
      }
    });
    on<LoadMoreRepliesPressed>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true));

        _log.info('LoadMoreRepliesPressed');

        try {
          final comments = await repo.lemmyRepo.getComments(
            postId: postId,
            parentId: event.id,
            sortType: state.sortType,
          );

          _log.info('Recieved ${comments.length} comments');

          emit(
            state.copyWith(
              comments: {...state.comments ?? [], ...comments}.toList(),
              isLoading: false,
            ),
          );
        } catch (err) {
          _log.warning(err);
        }
      },
      transformer: droppable(),
    );
  }

  final ServerRepo repo;
  final int postId;
}

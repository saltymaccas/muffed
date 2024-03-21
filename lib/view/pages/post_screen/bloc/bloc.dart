import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:logging/logging.dart';
import 'package:muffed/domain/lemmy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:muffed/view/widgets/comment/models/models.dart';

import '../../../widgets/content_scroll_view/view/view.dart';

part 'event.dart';
part 'state.dart';
part 'bloc.freezed.dart';

final _log = Logger('CommentScreenBloc');

/// The bloc for the content screen
class CommentScrollBloc extends Bloc<CommentScrollEvent, CommentScrollState> {
  CommentScrollBloc({required LemmyRepo lemmyRepo, required this.postId})
      : lem = lemmyRepo,
        super(
          const CommentScrollState(
            status: PagedScrollViewStatus.idle,
            pagesLoaded: 0,
            allPagesLoaded: false,
            sort: CommentSortType.hot,
          ),
        ) {
    on<CommentScrollInitialised>(_onCommentScrollInitalised);
    on<NearCommentScrollEnd>(_onNearCommentScrollEnd);
  }

  Future<void> _onCommentScrollInitalised(
    CommentScrollInitialised event,
    Emitter<CommentScrollState> emit,
  ) async {
    const pageToLoad = 1;

    emit(state.copyWith(status: PagedScrollViewStatus.loading));

    try {
      final response = await _loadComments(pageToLoad);
      emit(
        state.copyWith(
          comments: response,
          status: PagedScrollViewStatus.idle,
        ),
      );
    } catch (e, s) {
      _log.warning(
        '',
        e,
        s,
      );
      emit(
        state.copyWith(
          status: PagedScrollViewStatus.failure,
          errorMessage: _toErrorMessage(e),
        ),
      );
    }
  }

  Future<void> _onNearCommentScrollEnd(
    NearCommentScrollEnd event,
    Emitter<CommentScrollState> emit,
  ) async {
    if (state.allPagesLoaded) return;

    final pageToLoad = state.pagesLoaded + 1;

    emit(state.copyWith(status: PagedScrollViewStatus.loadingMore));

    try {
      final response = await _loadComments(pageToLoad);
      emit(
        state.copyWith(
          status: PagedScrollViewStatus.idle,
          pagesLoaded: pageToLoad,
          comments: [...state.comments ?? [], ...response],
          allPagesLoaded: response.isEmpty,
        ),
      );
    } catch (e, s) {
      _log.warning('', e, s);
      emit(
        state.copyWith(
          status: PagedScrollViewStatus.loadingMoreFailure,
          errorMessage: _toErrorMessage(e),
        ),
      );
    }
  }

  Future<List<CommentTree>> _loadComments(int page) async {
    final run = GetComments(
      page: page,
      postId: postId,
      type: ListingType.all,
      maxDepth: 8,
    );
    final response = await lem.run(run);
    final commentTree = CommentTree.assembleCommentTree(response.comments);
    return commentTree;
  }

  String _toErrorMessage(Object e) {
    return 'error of type ${e.runtimeType} occured';
  }

  final LemmyRepo lem;
  final int postId;
}

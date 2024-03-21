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
            allPagedLoaded: false,
            sort: CommentSortType.hot,
          ),
        ) {
    on<CommentScrollInitialised>(_onCommentScrollInitalised);
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
    }
  }

  Future<List<CommentTree>> _loadComments(int page) async {
    final run = GetComments(
      page: page,
      postId: postId,
      type: ListingType.all,
    );
    final response = await lem.run(run);
    return CommentTree.assembleCommentTree(response.comments);
  }

  final LemmyRepo lem;
  final int postId;
}

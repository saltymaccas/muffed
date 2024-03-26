import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:logging/logging.dart';
import 'package:muffed/domain/lemmy/lemmy.dart';
import 'package:muffed/view/widgets/content_scroll_view/content_scroll_view.dart';

part 'scroll.freezed.dart';

final _log = Logger('CommunityScrollBloc');

sealed class CommunityScrollEvent {}

class ScrollInitialised extends CommunityScrollEvent {}

class ScrollEndReached extends CommunityScrollEvent {}

class CommunityScrollBloc
    extends Bloc<CommunityScrollEvent, CommunityScrollState> {
  CommunityScrollBloc({
    required LemmyRepo lemmyRepo,
    required this.communityId,
  })  : lem = lemmyRepo,
        super(
          const CommunityScrollState(
            status: PagedScrollViewStatus.idle,
            sort: SortType.active,
            pagesLoaded: 0,
          ),
        ) {
    on<ScrollInitialised>(_loadFirst);
    on<ScrollEndReached>(_loadNext, transformer: droppable());
  }

  Future<void> _loadFirst(
    CommunityScrollEvent event,
    Emitter<CommunityScrollState> emit,
  ) async {
    const pageToLoad = 1;

    emit(state.copyWith(status: PagedScrollViewStatus.loading));

    try {
      final response = await _loadPage(pageToLoad);
      emit(
        state.copyWith(
          status: PagedScrollViewStatus.idle,
          posts: response,
          pagesLoaded: pageToLoad,
        ),
      );
    } catch (e, s) {
      emit(
        state.copyWith(
          status: PagedScrollViewStatus.failure,
          errorMessage: _toErrorMessage(e),
        ),
      );
      _log.warning('error occured when running _loadFirst', e, s);
    }
  }

  Future<void> _loadNext(
    CommunityScrollEvent event,
    Emitter<CommunityScrollState> emit,
  ) async {
    final pageToLoad = state.pagesLoaded + 1;
    emit(state.copyWith(status: PagedScrollViewStatus.loadingMore));
    try {
      final response = await _loadPage(pageToLoad);
      emit(
        state.copyWith(
          status: PagedScrollViewStatus.idle,
          pagesLoaded: pageToLoad,
          posts: [...state.posts ?? [], ...response],
        ),
      );
    } catch (e, s) {
      emit(
        state.copyWith(
          status: PagedScrollViewStatus.loadingMoreFailure,
          errorMessage: _toErrorMessage(e),
        ),
      );
      _log.warning('error occured when _loadNext called', e, s);
    }
  }

  Future<List<PostView>> _loadPage(
    int page,
  ) async {
    final response = await lem
        .run(GetPosts(sort: state.sort, page: page, communityId: communityId));
    return response.posts;
  }

  String _toErrorMessage(Object err) {
    return 'Error of type ${err.runtimeType} occurred';
  }

  final LemmyRepo lem;
  final int communityId;
}

@freezed
class CommunityScrollState with _$CommunityScrollState {
  const factory CommunityScrollState({
    required PagedScrollViewStatus status,
    required int pagesLoaded,
    required SortType sort,
    List<PostView>? posts,
    String? errorMessage,
  }) = _CommunityScrollState;
}

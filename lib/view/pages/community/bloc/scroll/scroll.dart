import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:muffed/domain/lemmy.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/widgets/content_scroll_view/content_scroll_view.dart';

part 'scroll.freezed.dart';

final _log = Logger('CommunityScrollBloc');

sealed class CommunityScrollEvent {}

class ScrollInitialised extends CommunityScrollEvent {}

class CommunityScrollBloc
    extends Bloc<CommunityScrollEvent, CommunityScrollState> {
  CommunityScrollBloc({
    required LemmyRepo lemmyRepo,
    required this.communityId,
  })  : lem = lemmyRepo,
        super(
          const CommunityScrollState(
            status: PagedScrollViewStatus.idle,
            sort: LemmySortType.active,
          ),
        ) {
    on<ScrollInitialised>(_loadFirst);
  }

  Future<void> _loadFirst(
    CommunityScrollEvent event,
    Emitter<CommunityScrollState> emit,
  ) async {
    emit(state.copyWith(status: PagedScrollViewStatus.loading));

    try {
      final result = await lem.getPosts(
        communityId: communityId,
        sortType: state.sort,
      );
      emit(state.copyWith(posts: result, status: PagedScrollViewStatus.idle));
    } catch (err, stackTrace) {
      _log.warning('Failed to load community posts', err, stackTrace);
      emit(
        state.copyWith(
          status: PagedScrollViewStatus.failure,
          errorMessage: _toErrorMessage(err),
        ),
      );
    }
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
    required LemmySortType sort,
    List<LemmyPost>? posts,
    String? errorMessage,
  }) = _CommunityScrollState;
}

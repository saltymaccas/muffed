import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:logging/logging.dart';
import 'package:muffed/domain/lemmy/lemmy.dart';
import 'package:muffed/view/pages/home/home.dart';

part 'controller.freezed.dart';

final _log = Logger('HomeTabViewController');

class HomeTabViewController extends Cubit<HomeTabViewModel> {
  HomeTabViewController({required LemmyRepo lemmyRepo})
      : lem = lemmyRepo,
        super(
          const HomeTabViewModel(
            status: HomeTabViewStatus.idle,
            endReached: false,
            pagesLoaded: 0,
          ),
        );

  Future<void> loadNextPage() async {
    if (state.status == HomeTabViewStatus.loadingNext) return;
    if (state.sortType == null) {
      _log.warning('load next page fail: loadedSortType == null');
      return;
    }
    if (state.loadedContentType == null) {
      _log.warning('load next page fail: loadedContentType == null');
      return;
    }
    if (state.items == null) {
      _log.warning('load next page fail: items == null');
      return;
    }

    final pageToLoad = state.pagesLoaded + 1;

    emit(state.copyWith(status: HomeTabViewStatus.loadingNext));
    try {
      final result = await _retrieveItems(
        page: pageToLoad,
        sortType: state.sortType!,
        contentType: state.loadedContentType!,
      );
      emit(
        state.copyWith(
          items: [...state.items!, ...result],
          pagesLoaded: pageToLoad,
          status: HomeTabViewStatus.idle,
        ),
      );
    } catch (err, stackTrace) {
      _log.warning('loading next failed', [err, stackTrace]);
      emit(
        state.copyWith(status: HomeTabViewStatus.loadingNextFailure),
      );
    }
  }

  Future<void> loadInitialContent({
    required SortType sortType,
    required HomeContentType contentType,
  }) async {
    emit(state.copyWith(status: HomeTabViewStatus.loading));
    try {
      final result = await _retrieveItems(
        page: 1,
        sortType: sortType,
        contentType: contentType,
      );
      emit(
        state.copyWith(
          sortType: sortType,
          loadedContentType: contentType,
          items: result,
          pagesLoaded: 1,
          status: HomeTabViewStatus.idle,
        ),
      );
    } catch (err, stackTrace) {
      _log.warning([err, stackTrace]);
      emit(
        state.copyWith(
          status: HomeTabViewStatus.failure,
          errorMessage: _toErrorMessage(err),
        ),
      );
    }
  }

  String _toErrorMessage(Object err) {
    return 'Error of type "${err.runtimeType}" occured';
  }

  Future<List<PostView>> _retrieveItems({
    required int page,
    required SortType sortType,
    required HomeContentType contentType,
  }) async {
    late final ListingType listingType;

    switch (contentType) {
      case (HomeContentType.popular):
        listingType = ListingType.all;
      case (HomeContentType.local):
        listingType = ListingType.local;
      case (HomeContentType.subscibed):
        listingType = ListingType.subscribed;
    }

    final posts = await lem
        .run(GetPosts(sort: state.sortType, page: page, type: listingType));

    return posts.posts;
  }

  final LemmyRepo lem;
}

enum HomeTabViewStatus {
  idle,
  loading,
  failure,
  loadingNext,
  loadingNextFailure,
}

@freezed
class HomeTabViewModel with _$HomeTabViewModel {
  const factory HomeTabViewModel({
    required int pagesLoaded,
    required bool endReached,
    required HomeTabViewStatus status,
    List<PostView>? items,
    String? errorMessage,
    SortType? sortType,
    HomeContentType? loadedContentType,
  }) = _HomeTabViewModel;
}

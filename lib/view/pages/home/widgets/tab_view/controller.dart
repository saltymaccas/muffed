import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:muffed/domain/lemmy.dart';
import 'package:muffed/domain/server_repo.dart';
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
    if (state.loadedSortType == null) {
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
        sortType: state.loadedSortType!,
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
    required LemmySortType sortType,
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
          loadedSortType: sortType,
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

  Future<List<LemmyPost>> _retrieveItems({
    required int page,
    required LemmySortType sortType,
    required HomeContentType contentType,
  }) async {
    late final LemmyListingType listingType;

    switch (contentType) {
      case (HomeContentType.popular):
        listingType = LemmyListingType.all;
      case (HomeContentType.local):
        listingType = LemmyListingType.local;
      case (HomeContentType.subscibed):
        listingType = LemmyListingType.subscribed;
    }

    final posts = await lem.getPosts(
      page: page,
      sortType: sortType,
      listingType: listingType,
    );

    return posts;
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
    List<LemmyPost>? items,
    String? errorMessage,
    LemmySortType? loadedSortType,
    HomeContentType? loadedContentType,
  }) = _HomeTabViewModel;
}

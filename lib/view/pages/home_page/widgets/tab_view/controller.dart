import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:muffed/domain/lemmy.dart';
import 'package:muffed/domain/server_repo.dart';

part 'controller.freezed.dart';

final _log = Logger('HomeTabViewController');

class HomeTabViewController<T> extends Cubit<HomeTabViewModel<T>> {
  HomeTabViewController({required LemmyRepo lemmyRepo})
      : lem = lemmyRepo,
        super(
          const HomeTabViewModel(
            items: [],
            status: HomeTabViewStatus.idle,
            endReached: false,
            pagesLoaded: 0,
          ),
        );

  Future<void> loadContent({
    required LemmySortType sortType,
    required ContentType contentType,
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

  Future<List<T>> _retrieveItems({
    required int page,
    required LemmySortType sortType,
    required ContentType contentType,
  }) async {
    late final LemmyListingType listingType;

    switch (contentType) {
      case (ContentType.popular):
        listingType = LemmyListingType.all;
      case (ContentType.local):
        listingType = LemmyListingType.local;
      case (ContentType.subscibed):
        listingType = LemmyListingType.subscribed;
    }

    return await lem.getPosts(
      page: page,
      sortType: sortType,
      listingType: listingType,
    ) as List<T>;
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

enum ContentType {
  popular,
  subscibed,
  local,
}

@freezed
class HomeTabViewModel<T> with _$HomeTabViewModel<T> {
  const factory HomeTabViewModel({
    required List<T> items,
    required int pagesLoaded,
    required bool endReached,
    required HomeTabViewStatus status,
    String? errorMessage,
    LemmySortType? loadedSortType,
    ContentType? loadedContentType,
  }) = _HomeTabViewModel;
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:muffed/domain/lemmy.dart';
import 'package:muffed/domain/server_repo.dart';

part 'controller.freezed.dart';

final _log = Logger('Search');

enum SearchStatus {
  initial,
  loading,
  success,
  failure,
  loadMoreFailure,
  loadingMore,
  reloading,
}

enum SearchType {
  posts,
  users,
  communities,
  comments,
}

class SearchCubit extends Cubit<SearchModel> {
  SearchCubit({required LemmyRepo lemmyRepo, required this.searchType})
      : lem = lemmyRepo,
        super(
          const SearchModel(
            items: [],
            status: SearchStatus.initial,
            pagesLoaded: 0,
            allPagesLoaded: false,
          ),
        );

  Future<void> loadNextPage() async {
    if (state.loadedSortType == null) return;
    if (state.loadedQuery == null) return;
    if (state.status == SearchStatus.loadingMore) return;

    emit(state.copyWith(status: SearchStatus.loadingMore));

    await _search(
      query: state.loadedQuery!,
      sortType: state.loadedSortType!,
      page: state.pagesLoaded + 1,
    )
        .then(
          (value) => emit(
            state.copyWith(
              items: state.items + value,
              status: SearchStatus.success,
              pagesLoaded: state.pagesLoaded + 1,
            ),
          ),
        )
        .onError(_onError);
  }

  Future<void> search({
    required String query,
    required LemmySortType sortType,
  }) async {
    emit(state.copyWith(status: SearchStatus.loading));

    await _search(query: query, sortType: sortType, page: 1)
        .then(
          (value) => emit(
            state.copyWith(
              status: SearchStatus.success,
              items: value,
              pagesLoaded: 1,
              loadedQuery: query,
              loadedSortType: sortType,
            ),
          ),
        )
        .onError(_onError);
  }

  void _onError(Object error, StackTrace stackTrace) {
    emit(
      state.copyWith(
        errorMessage: 'Error of type ${error.runtimeType} occured',
      ),
    );
    _log.warning(error);
  }

  Future<List<Object>> _search({
    required String query,
    required LemmySortType sortType,
    required int page,
  }) async {
    late final LemmySearchType reqSearchType;

    switch (searchType) {
      case (SearchType.communities):
        reqSearchType = LemmySearchType.communities;
      case (SearchType.users):
        reqSearchType = LemmySearchType.users;
      case (SearchType.posts):
        reqSearchType = LemmySearchType.posts;
      case (SearchType.comments):
        reqSearchType = LemmySearchType.comments;
    }

    final result = await lem.search(
      query: query,
      sortType: sortType,
      searchType: reqSearchType,
      page: page,
    );

    switch (searchType) {
      case (SearchType.communities):
        return result.lemmyCommunities ?? [];
      case (SearchType.users):
        return result.lemmyPersons ?? [];
      case (SearchType.posts):
        return result.lemmyPosts ?? [];
      case (SearchType.comments):
        return result.lemmyComments ?? [];
    }
  }

  final LemmyRepo lem;
  final SearchType searchType;
}

@freezed
class SearchModel with _$SearchModel {
  const factory SearchModel({
    required List<Object> items,
    required SearchStatus status,
    required int pagesLoaded,
    required bool allPagesLoaded,
    LemmySortType? loadedSortType,
    String? loadedQuery,
    String? errorMessage,
  }) = _SearchModel;
}

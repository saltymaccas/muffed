import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/domain/lemmy/lemmy.dart';
import 'package:muffed/utils/error.dart';
import 'package:muffed/view/widgets/content_scroll_view/content_scroll_view.dart';

part 'state.dart';
part 'event.dart';
part 'bloc.freezed.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.searchType, required this.lem})
      : super(
          const SearchState(
            sort: SortType.topAll,
            pagesLoaded: 0,
            status: PagedScrollViewStatus.idle,
            query: '',
            items: [],
          ),
        ) {
    on<Searched>(_onSearched);
    on<ReachedNearEndOfScroll>(_onReachedNearEndOfScroll);
  }

  Future<void> _onReachedNearEndOfScroll(
    ReachedNearEndOfScroll event,
    Emitter<SearchState> emit,
  ) async {
    final pageToLoad = state.pagesLoaded + 1;
    emit(state.copyWith(status: PagedScrollViewStatus.loadingMore));

    try {
      final response = await fetch(query: state.query, page: pageToLoad);
      emit(
        state.copyWith(
          status: PagedScrollViewStatus.idle,
          items: [...state.items ?? [], response],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PagedScrollViewStatus.loadingMoreFailure,
          errorMessage: _toErrorMessage(e),
        ),
      );
    }
  }

  Future<void> _onSearched(Searched event, Emitter<SearchState> emit) async {
    const pageToLoad = 1;
    emit(state.copyWith(status: PagedScrollViewStatus.loading));

    try {
      final response = await fetch(query: event.query, page: pageToLoad);
      emit(
        state.copyWith(
          status: PagedScrollViewStatus.idle,
          items: response,
          query: event.query,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PagedScrollViewStatus.failure,
          errorMessage: _toErrorMessage(e),
        ),
      );
    }
  }

  String _toErrorMessage(Object e) {
    return objectToErrorMessage(e);
  }

  Future<List<Object>> fetch({required String query, required int page}) async {
    final response = await lem
        .run(Search(q: query, type: searchType, sort: state.sort, page: page));

    switch (searchType) {
      case SearchType.comments:
        return response.comments;
      case SearchType.users:
        return response.users;
      case SearchType.communities:
        return response.communities;
      case SearchType.posts:
        return response.posts;
      case SearchType.all:
        return response.posts;
      case SearchType.url:
        return response.posts;
    }
  }

  final SearchType searchType;
  final LemmyRepo lem;
}

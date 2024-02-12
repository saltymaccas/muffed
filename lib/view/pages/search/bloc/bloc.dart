import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:muffed/domain/lemmy.dart';
import 'package:muffed/domain/server_repo.dart';

part 'event.dart';
part 'state.dart';
part 'bloc.freezed.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required this.lem,
    required LemmySearchType searchType,
    SearchState? initialState,
    int? communityId,
  }) : super(
          initialState ??
              SearchState(
                status: SearchStatus.initial,
                searchQuery: '',
                selectedSortType: LemmySortType.topAll,
                searchType: searchType,
                communityId: communityId,
                pagesLoaded: 0,
              ),
        ) {
    on<SearchRequested>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: SearchStatus.loading,
          ),
        );

        await lem
            .search(
              query: event.searchQuery,
              sortType: state.selectedSortType,
              communityId: state.communityId,
              searchType: state.searchType,
            )
            .then(
              (result) => emit(
                state.copyWith(
                  posts: result.lemmyPosts,
                  users: result.lemmyPersons,
                  communities: result.lemmyCommunities,
                  comments: result.lemmyComments,
                  status: SearchStatus.success,
                  pagesLoaded: 1,
                ),
              ),
            )
            .onError((err, stackTrace) {
          emit(
            state.copyWith(
              status: SearchStatus.failure,
              errorMessage: 'Error of type "${err.runtimeType}" occured',
            ),
          );
        });
      },
      transformer: restartable(),
    );
    on<SortTypeChanged>(
      (event, emit) async {
        emit(
          state.copyWith(
            selectedSortType: event.sortType,
            status: SearchStatus.loading,
          ),
        );

        await lem
            .search(
          query: state.searchQuery,
          searchType: state.searchType,
          sortType: state.selectedSortType,
          communityId: communityId,
        )
            .then((result) {
          emit(
            state.copyWith(
              pagesLoaded: 1,
              posts: result.lemmyPosts,
              comments: result.lemmyComments,
              communities: result.lemmyCommunities,
              users: result.lemmyPersons,
              status: SearchStatus.success,
            ),
          );
        }).onError((err, stackTrace) {
          emit(
            state.copyWith(
              errorMessage: 'Error of type "${err.runtimeType}" occured',
              status: SearchStatus.failure,
              selectedSortType: LemmySortType.topAll,
            ),
          );
        });
      },
      transformer: restartable(),
    );
    on<ReachedNearEndOfPage>(
      _onReachedNearEndOfPage,
      transformer: droppable(),
    );
    on<SearchAll>(_onSearchAll);
  }

  Future<void> _onReachedNearEndOfPage(
    ReachedNearEndOfPage event,
    Emitter<SearchState> emit,
  ) async {
    if (state.loadedSearchQuery == null) return;
    if (state.loadedSortType == null) return;

    emit(state.copyWith(status: SearchStatus.loadingMore));

    await lem
        .search(
      query: state.loadedSearchQuery!,
      sortType: state.loadedSortType!,
      page: state.pagesLoaded + 1,
      communityId: state.communityId,
      searchType: state.searchType,
    )
        .then(
      (result) {
        emit(
          state.copyWith(
            status: SearchStatus.success,
            pagesLoaded: state.pagesLoaded + 1,
            posts: [
              if (state.posts != null) ...state.posts!,
              if (result.lemmyPosts != null) ...result.lemmyPosts!,
            ],
            communities: [
              if (state.communities != null) ...state.communities!,
              if (result.lemmyCommunities != null) ...result.lemmyCommunities!,
            ],
            comments: [
              if (state.comments != null) ...state.comments!,
              if (result.lemmyComments != null) ...result.lemmyComments!,
            ],
            users: [
              if (state.users != null) ...state.users!,
              if (result.lemmyPersons != null) ...result.lemmyPersons!,
            ],
          ),
        );
      },
    ).onError((error, stackTrace) {
      emit(state.copyWith(status: SearchStatus.loadMoreFailure));
    });
  }

  void _onSearchAll(SearchAll event, Emitter<SearchState> emit) {
    emit(state.copyWith(communityId: null, communityName: null));
  }

  final LemmyRepo lem;
}

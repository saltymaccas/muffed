import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('SearchBloc');

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  ///
  SearchBloc({
    required this.repo,
    SearchState? initialState,
    int? communityId,
    String? communityName,
  }) : super(
          initialState ??
              SearchState(
                communityId: communityId,
                communityName: communityName,
              ),
        ) {
    on<SearchQueryChanged>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, searchQuery: event.searchQuery));

        try {
          final search = await repo.lemmyRepo.search(
            query: event.searchQuery,
            sortType: state.sortType,
            communityId: state.communityId,
          );

          emit(
            state.copyWith(
              loadedSearchQuery: event.searchQuery,
              comments: search.lemmyComments,
              posts: search.lemmyPosts,
              communities: search.lemmyCommunities,
              persons: search.lemmyPersons,
              isLoading: false,
              pagesLoaded: 1,
            ),
          );
        } catch (err, stackTrace) {
          emit(state.copyWith(isLoading: false, error: err));
          _log
            ..severe('Error: $err')
            ..severe('StackTrace: $stackTrace');
        }
      },
      transformer: restartable(),
    );
    on<SortTypeChanged>(
      (event, emit) async {
        // Saves last sort type so it can be changed back if failed to load
        final lastSortType = state.sortType;

        emit(state.copyWith(sortType: event.sortType, isLoading: true));

        try {
          final search = await repo.lemmyRepo.search(
            query: state.searchQuery,
            sortType: state.sortType,
            communityId: communityId,
          );
          emit(
            state.copyWith(
              loadedSortType: event.sortType,
              isLoading: false,
              communities: search.lemmyCommunities,
              comments: search.lemmyComments,
              posts: search.lemmyPosts,
              persons: search.lemmyPersons,
            ),
          );
        } catch (err, stackTrace) {
          emit(
            state.copyWith(
              isLoading: false,
              sortType: lastSortType,
              error: err,
            ),
          );
          _log
            ..severe('Error: $err')
            ..severe('StackTrace: $stackTrace');
        }
      },
      transformer: restartable(),
    );
    on<ReachedNearEndOfPage>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true));

        try {
          final searchResponse = await repo.lemmyRepo.search(
            query: state.loadedSearchQuery,
            sortType: state.sortType,
            searchType: LemmySearchType.all,
            page: state.pagesLoaded + 1,
            communityId: state.communityId,
          );
          emit(
            state.copyWith(
              isLoading: false,
              pagesLoaded: state.pagesLoaded + 1,
              communities: [
                ...state.communities,
                ...?searchResponse.lemmyCommunities,
              ],
              persons: [...state.persons, ...searchResponse.lemmyPersons ?? []],
              posts: [...state.posts, ...searchResponse.lemmyPosts ?? []],
              comments: [
                ...state.comments,
                ...searchResponse.lemmyComments ?? [],
              ],
            ),
          );
        } catch (err, stackTrace) {
          emit(
            state.copyWith(
              isLoading: false,
              error: err,
            ),
          );
          _log
            ..severe('Error: $err')
            ..severe('StackTrace: $stackTrace');
        }
      },
      transformer: droppable(),
    );
    on<SearchAll>((event, emit) {
      final communityName = state.communityName;
      final communityId = state.communityId;

      emit(state.copyWith(setCommunityNameAndIdToNull: true));

      try {
        add(SearchQueryChanged(searchQuery: state.searchQuery));
      } catch (err, stackTrace) {
        emit(
          state.copyWith(
            communityName: communityName,
            communityId: communityId,
          ),
        );
        _log
          ..severe('Error: $err')
          ..severe('StackTrace: $stackTrace');
      }
    });
  }

  final ServerRepo repo;
}

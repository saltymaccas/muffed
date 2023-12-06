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
    SearchState? initialState,
    int? communityId,
    String? communityName,
    String? searchQuery,
  }) : super(
          initialState ??
              SearchState(
                communityId: communityId,
                communityName: communityName,
                searchQuery: searchQuery ?? '',
              ),
        ) {
    on<SearchRequested>(
      (event, emit) async {
        emit(state.copyWith(searchQuery: event.searchQuery));
      },
    );
    on<SortTypeChanged>(
      (event, emit) async {
        emit(state.copyWith(sortType: event.sortType));
      },
    );
    on<SearchAllRequested>(
      (event, emit) async {
        emit(
          state.copyWith(
            setCommunityNameAndIdToNull: true,
          ),
        );
      },
    );
  }
}

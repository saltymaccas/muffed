import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'event.dart';

part 'state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.repo}) : super(SearchState()) {
    on<SearchQueryChanged>((event, emit) async {
      final search = await repo.lemmyRepo.search(query: event.searchQuery);

      emit(state.copyWith(
        comments: search.lemmyComments,
        posts: search.lemmyPosts,
        communities: search.lemmyCommunities,
        people: search.lemmyPersons,
      ));
    }, transformer: restartable());
  }

  final ServerRepo repo;
}

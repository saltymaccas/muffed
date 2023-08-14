part of 'bloc.dart';

sealed class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String searchQuery;

  SearchQueryChanged({required this.searchQuery});
}

class SortTypeChanged extends SearchEvent {
  SortTypeChanged({required this.sortType,required this.searchType});

  final LemmySortType sortType;
  final LemmySearchType searchType;
}

class ReachedNearEndOfPage extends SearchEvent {}
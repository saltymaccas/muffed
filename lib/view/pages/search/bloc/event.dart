part of 'bloc.dart';

sealed class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String searchQuery;

  SearchQueryChanged({required this.searchQuery});
}

class SortTypeChanged extends SearchEvent {
  SortTypeChanged(this.sortType);

  final LemmySortType sortType;
}

class ReachedNearEndOfPage extends SearchEvent {}

class SearchAll extends SearchEvent {}

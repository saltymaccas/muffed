part of 'bloc.dart';

sealed class SearchEvent {}

class SearchQueryChanged extends SearchEvent {

  SearchQueryChanged({required this.searchQuery});
  final String searchQuery;
}

class SortTypeChanged extends SearchEvent {
  SortTypeChanged(this.sortType);

  final LemmySortType sortType;
}

class ReachedNearEndOfPage extends SearchEvent {}

class SearchAll extends SearchEvent {}
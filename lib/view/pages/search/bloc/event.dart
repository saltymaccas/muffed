part of 'bloc.dart';

sealed class SearchEvent {}

class SearchRequested extends SearchEvent {
  SearchRequested();
}

class SearchQueryChanged extends SearchEvent {
  SearchQueryChanged(this.newQuery);

  final String newQuery;
}

class SortTypeChanged extends SearchEvent {
  SortTypeChanged(this.sortType);

  final LemmySortType sortType;
}

class ReachedNearEndOfPage extends SearchEvent {}

class SearchAll extends SearchEvent {}

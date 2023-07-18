part of 'bloc.dart';

sealed class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String searchQuery;

  SearchQueryChanged(this.searchQuery);
}
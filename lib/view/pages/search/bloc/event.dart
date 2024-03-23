part of 'bloc.dart';

sealed class SearchEvent {}

class Searched extends SearchEvent {
  Searched({required this.query});
  final String query;
}

class ReachedNearEndOfScroll extends SearchEvent {}

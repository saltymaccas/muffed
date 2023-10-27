part of 'bloc.dart';

sealed class MentionsEvent {}

class Initialize extends MentionsEvent {}

class ReachedEndOfScroll extends MentionsEvent {}

class ShowAllToggled extends MentionsEvent {}

class Refresh extends MentionsEvent {}

class MarkedAsRead extends MentionsEvent {
  MarkedAsRead({required this.id});

  final int id;
}

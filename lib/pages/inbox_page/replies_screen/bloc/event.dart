part of 'bloc.dart';

sealed class RepliesEvent {}

class Initialize extends RepliesEvent {}

class ReachedEndOfScroll extends RepliesEvent {}

class ShowAllToggled extends RepliesEvent {}

class Refresh extends RepliesEvent {}

class MarkedAsRead extends RepliesEvent {
  MarkedAsRead({required this.id});

  final int id;
}

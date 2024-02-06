part of 'bloc.dart';

sealed class RepliesEvent {}

class Initialize extends RepliesEvent {}

class ReachedEndOfScroll extends RepliesEvent {}

class ShowAllToggled extends RepliesEvent {}

class Refresh extends RepliesEvent {}

class MarkAsReadToggled extends RepliesEvent {
  MarkAsReadToggled({required this.id, required this.index});

  final int id;
  final int index;
}

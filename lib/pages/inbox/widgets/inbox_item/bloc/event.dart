part of 'bloc.dart';

@immutable
abstract class InboxItemEvent {}

class ReadStatusToggled extends InboxItemEvent {
  ReadStatusToggled(this.id);

  final int id;
}

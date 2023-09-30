part of 'bloc.dart';

sealed class CreateCommentEvent {}

class Submitted extends CreateCommentEvent {}

class NewCommentTextboxChanged extends CreateCommentEvent {
  NewCommentTextboxChanged(this.text);

  final String text;
}

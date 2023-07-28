part of 'bloc.dart';

sealed class CommentScreenEvent {}

final class InitializeEvent extends CommentScreenEvent{}

final class ReachedNearEndOfScroll extends CommentScreenEvent {}

final class UserCommented extends CommentScreenEvent {

  UserCommented(this.comment, this.onSuccess);

  final void Function() onSuccess;
  final String comment;
}

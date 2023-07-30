part of 'bloc.dart';

sealed class CommentScreenEvent {}

final class InitializeEvent extends CommentScreenEvent{}

final class ReachedNearEndOfScroll extends CommentScreenEvent {}

final class UserCommented extends CommentScreenEvent {

  UserCommented(this.comment, this.onSuccess, this.onError);

  final void Function() onSuccess;
  final void Function() onError;
  final String comment;
}

final class PullDownRefresh extends CommentScreenEvent{}

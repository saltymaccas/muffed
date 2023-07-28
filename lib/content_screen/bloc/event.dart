part of 'bloc.dart';

sealed class ContentScreenEvent {}

final class InitializeEvent extends ContentScreenEvent{}

final class ReachedNearEndOfScroll extends ContentScreenEvent {}

final class UserCommented extends ContentScreenEvent {

  UserCommented(this.comment, this.onSuccess);

  final void Function() onSuccess;
  final String comment;
}

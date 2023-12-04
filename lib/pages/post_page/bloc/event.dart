part of 'bloc.dart';

sealed class PostScreenEvent {}

final class InitializeEvent extends PostScreenEvent {}

final class ReachedNearEndOfScroll extends PostScreenEvent {}

final class UserCommented extends PostScreenEvent {
  UserCommented({
    required this.comment,
    required this.onSuccess,
    required this.onError,
  });

  final void Function() onSuccess;
  final void Function() onError;
  final String comment;
}

final class UserRepliedToComment extends PostScreenEvent {
  UserRepliedToComment({
    required this.onSuccess,
    required this.onError,
    required this.comment,
    required this.commentId,
  });

  final void Function() onSuccess;
  final void Function() onError;
  final int commentId;
  final String comment;
}

final class PullDownRefresh extends PostScreenEvent {}

final class SortTypeChanged extends PostScreenEvent {
  SortTypeChanged(this.sortType);

  final LemmyCommentSortType sortType;
}

final class LoadMoreRepliesPressed extends PostScreenEvent {
  LoadMoreRepliesPressed({required this.id});

  final int id;
}

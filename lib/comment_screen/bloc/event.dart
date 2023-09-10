part of 'bloc.dart';

sealed class CommentScreenEvent {}

final class InitializeEvent extends CommentScreenEvent {}

final class ReachedNearEndOfScroll extends CommentScreenEvent {}

final class UserCommented extends CommentScreenEvent {
  UserCommented({
    required this.comment,
    required this.onSuccess,
    required this.onError,
  });

  final void Function() onSuccess;
  final void Function() onError;
  final String comment;
}

final class UserRepliedToComment extends CommentScreenEvent {
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

final class PullDownRefresh extends CommentScreenEvent {}

final class SortTypeChanged extends CommentScreenEvent {
  SortTypeChanged(this.sortType);

  final LemmyCommentSortType sortType;
}

final class LoadMoreRepliesPressed extends CommentScreenEvent {
  LoadMoreRepliesPressed({required this.id});

  final int id;
}

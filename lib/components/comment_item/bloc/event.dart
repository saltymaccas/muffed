part of 'bloc.dart';

sealed class CommentItemEvent {}

class LoadChildrenRequested extends CommentItemEvent {
  LoadChildrenRequested(this.sortType);

  final LemmyCommentSortType sortType;
}

class UpvotePressed extends CommentItemEvent {}

class DownvotePressed extends CommentItemEvent {}

class MinimiseToggled extends CommentItemEvent {}

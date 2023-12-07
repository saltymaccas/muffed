part of 'bloc.dart';

sealed class CommentItemEvent {}

class LoadChildrenRequested extends CommentItemEvent {}

class UpvotePressed extends CommentItemEvent {}

class DownvotePressed extends CommentItemEvent {}

class MinimiseToggled extends CommentItemEvent {}

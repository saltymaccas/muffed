part of 'bloc.dart';

sealed class CommentItemEvent {}

class UpvotePressed extends CommentItemEvent {}

class DownvotePressed extends CommentItemEvent {}

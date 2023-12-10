part of 'bloc.dart';

sealed class CommentEvent {}

class LoadChildrenRequested extends CommentEvent {}

class UpvotePressed extends CommentEvent {}

class DownvotePressed extends CommentEvent {}

part of 'bloc.dart';

sealed class CommentScrollEvent {}

class CommentScrollInitialised extends CommentScrollEvent {}

class NearCommentScrollEnd extends CommentScrollEvent {}

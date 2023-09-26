part of 'bloc.dart';

sealed class PostItemEvent {}

class UpvotePressed extends PostItemEvent {}

class DownvotePressed extends PostItemEvent {}

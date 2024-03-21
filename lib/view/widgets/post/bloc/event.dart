part of 'bloc.dart';

sealed class PostItemEvent {}

class UpvotePressed extends PostItemEvent {}

class DownvotePressed extends PostItemEvent {}

class SavePostToggled extends PostItemEvent {}

class Initialised extends PostItemEvent {}

part of 'bloc.dart';

sealed class PostEvent {}

class UpvotePressed extends PostEvent {}

class DownvotePressed extends PostEvent {}

class SavePostToggled extends PostEvent {}

class Initialize extends PostEvent {}

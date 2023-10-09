part of 'bloc.dart';

sealed class SavedPostsEvent {}

class Initialize extends SavedPostsEvent {}

class ReachedNearEndOfScroll extends SavedPostsEvent {}

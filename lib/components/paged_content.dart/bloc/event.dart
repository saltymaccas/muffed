part of 'bloc.dart';

class PagedContentEvent {}

class LoadNextPageRequested extends PagedContentEvent {}

class ReloadRequested extends PagedContentEvent {}

class LoadNewQueryRequested extends PagedContentEvent {
  LoadNewQueryRequested(this.query);

  final GetPosts query;
}

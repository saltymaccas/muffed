part of 'bloc.dart';

final class HomeEvent {
  const HomeEvent();
}

final class HomeCreated extends HomeEvent {}

final class RetriedFromError extends HomeEvent {}

final class SortChanged extends HomeEvent {
  const SortChanged(this.sort);

  final SortType sort;
}

final class ReachedNearScrollEnd extends HomeEvent {}

final class PullDownReload extends HomeEvent {}

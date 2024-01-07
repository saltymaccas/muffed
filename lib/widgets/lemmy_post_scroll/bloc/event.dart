part of 'bloc.dart';

final class LemmyPostScrollEvent {
  const LemmyPostScrollEvent();
}

final class Initialised extends LemmyPostScrollEvent {}

final class SortChanged extends LemmyPostScrollEvent {
  const SortChanged(this.sort);

  final SortType sort;
}

final class ReachedNearScrollEnd extends LemmyPostScrollEvent {}

final class PullDownReload extends LemmyPostScrollEvent {}

final class Retry extends LemmyPostScrollEvent {}

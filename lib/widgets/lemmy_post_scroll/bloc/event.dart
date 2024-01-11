part of 'bloc.dart';

final class LemmyPostScrollEvent {
  const LemmyPostScrollEvent();
}

final class Initialised extends LemmyPostScrollEvent {}

final class QueryChanged extends LemmyPostScrollEvent {
  const QueryChanged(this.query);

  final GetPosts query;
}

final class ReachedNearScrollEnd extends LemmyPostScrollEvent {}

final class PullDownReload extends LemmyPostScrollEvent {}

final class Retry extends LemmyPostScrollEvent {}

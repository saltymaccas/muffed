part of 'bloc.dart';

sealed class ContentScrollEvent {}

final class Initialise extends ContentScrollEvent {
  Initialise({this.loadInitialContent = true});

  final bool loadInitialContent;
}

final class PullDownRefresh extends ContentScrollEvent {}

final class ReachedNearEndOfScroll extends ContentScrollEvent {}

final class RetrieveContentMethodChanged extends ContentScrollEvent {
  RetrieveContentMethodChanged(this.retrieveContent,
      {this.persistContent = true});

  final ContentRetriever retrieveContent;
  final bool persistContent;
}

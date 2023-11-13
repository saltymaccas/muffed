part of 'bloc.dart';

sealed class CommunityScreenEvent {}

class Initialize extends CommunityScreenEvent {}

class ReachedEndOfScroll extends CommunityScreenEvent {}

class SortTypeChanged extends CommunityScreenEvent {
  SortTypeChanged(this.sortType);

  final LemmySortType sortType;
}

class ToggledSubscribe extends CommunityScreenEvent {}

class PullDownReload extends CommunityScreenEvent {}

class BlockToggled extends CommunityScreenEvent {}

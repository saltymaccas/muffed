part of 'bloc.dart';

sealed class DynamicNavigationBarEvent {}

final class GoneToNewMainPage extends DynamicNavigationBarEvent {
  final int index;

  GoneToNewMainPage(this.index);
}

final class PageAdded extends DynamicNavigationBarEvent{
  final PageInfo pageInfo;
  final int itemIndex;

  PageAdded(this.pageInfo, this.itemIndex);
}

final class PageRemoved extends DynamicNavigationBarEvent{
  final int itemIndex;

  PageRemoved(this.itemIndex);
}
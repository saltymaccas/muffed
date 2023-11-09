part of 'bloc.dart';

sealed class DynamicNavigationBarEvent {}

final class GoneToNewMainPage extends DynamicNavigationBarEvent {
  final int index;

  GoneToNewMainPage(this.index);
}

final class PageAdded extends DynamicNavigationBarEvent {
  final PageInfo pageInfo;
  final Pages page;

  PageAdded(this.pageInfo, this.page);
}

final class PageRemoved extends DynamicNavigationBarEvent {
  final Pages page;

  PageRemoved(this.page);
}

final class EditPageActions extends DynamicNavigationBarEvent {
  EditPageActions(
      {required this.context, required this.itemIndex, required this.actions});

  final int itemIndex;
  final List<Widget> actions;
  final BuildContext context;
}

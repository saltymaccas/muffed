part of 'bloc.dart';

sealed class DynamicNavigationBarEvent {}

final class GoneToNewMainPage extends DynamicNavigationBarEvent {

  GoneToNewMainPage(this.index);
  final int index;
}

final class PageAdded extends DynamicNavigationBarEvent {

  PageAdded(this.pageInfo, this.page);
  final PageInfo pageInfo;
  final Pages page;
}

final class PageRemoved extends DynamicNavigationBarEvent {

  PageRemoved(this.page);
  final Pages page;
}

final class EditPageActions extends DynamicNavigationBarEvent {
  EditPageActions(
      {required this.context, required this.itemIndex, required this.actions,});

  final int itemIndex;
  final List<Widget> actions;
  final BuildContext context;
}

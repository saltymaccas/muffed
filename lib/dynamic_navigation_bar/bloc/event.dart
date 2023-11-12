part of 'bloc.dart';

sealed class DynamicNavigationBarEvent {}

final class GoneToNewMainPage extends DynamicNavigationBarEvent {
  GoneToNewMainPage(this.index);
  final int index;
}

final class PageAdded extends DynamicNavigationBarEvent {
  PageAdded({required this.pageInfo, required this.page, this.id});
  final PageInfo pageInfo;
  final Pages page;
  final String? id;
}

final class PageRemoved extends DynamicNavigationBarEvent {
  PageRemoved(this.page);
  final Pages page;
}

final class EditPageActions extends DynamicNavigationBarEvent {
  EditPageActions({
    required this.context,
    required this.page,
    required this.actions,
    required this.id,
  });

  final Pages page;
  final String id;
  final List<Widget> actions;
  final BuildContext context;
}

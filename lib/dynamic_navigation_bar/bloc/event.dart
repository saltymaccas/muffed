part of 'bloc.dart';

sealed class DynamicNavigationBarEvent {}

final class GoneToNewMainPage extends DynamicNavigationBarEvent {
  final int index;

  GoneToNewMainPage(this.index);
}

final class AddActions extends DynamicNavigationBarEvent{
  final List<Widget> actions;
  final int itemIndex;

  AddActions(this.actions, this.itemIndex);
}

final class RemoveActions extends DynamicNavigationBarEvent{
  final int itemIndex;

  RemoveActions(this.itemIndex);
}
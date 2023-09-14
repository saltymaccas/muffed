part of 'bloc.dart';

sealed class MuffedPopupMenuEvent {}

/// When an Expandable item in the menu is pressed
class ExpandableItemPressed extends MuffedPopupMenuEvent {
  ExpandableItemPressed(this.items);

  final List<Widget> items;
}

/// When expandable item is pressed the menu will show a new set of items
/// including a back button which will send the user back.
class BackPressed extends MuffedPopupMenuEvent {}

class SelectedValueChanged extends MuffedPopupMenuEvent {
  SelectedValueChanged(this.value);

  final Object value;
}
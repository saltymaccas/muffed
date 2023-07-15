part of 'bloc.dart';

final class DynamicNavigationBarState extends Equatable {
  // Item is the main buttons that change the page
  final int selectedItemIndex;

  // actions are the widgets that will emerge from the item
  final Map<int, List<List<Widget>>> actions;

  const DynamicNavigationBarState(
      {this.selectedItemIndex = 0, this.actions = const {0: [], 1: []}});

  @override
  List<Object?> get props => [selectedItemIndex, actions];

  DynamicNavigationBarState copyWith({
    int? selectedItemIndex,
    Map<int, List<List<Widget>>>? actions,
  }) {
    return DynamicNavigationBarState(
      selectedItemIndex: selectedItemIndex ?? this.selectedItemIndex,
      actions: actions ?? this.actions,
    );
  }
}

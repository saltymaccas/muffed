part of 'bloc.dart';

/// The state for the popup menu.
class MuffedPopupMenuState extends Equatable {
  MuffedPopupMenuState({required this.items, this.selectedValue = 1})
      : currentItems = items.last;

  final List<List<Widget>> items;
  final List<Widget> currentItems;
  final Object selectedValue;

  @override
  List<Object?> get props => [items, selectedValue, currentItems];

  MuffedPopupMenuState copyWith({
    List<List<Widget>>? items,
    Object? selectedValue,
  }) {
    return MuffedPopupMenuState(
      items: items != null ? List<List<Widget>>.from(items) : this.items,
      selectedValue: selectedValue ?? this.selectedValue,
    );
  }
}

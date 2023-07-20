part of 'bloc.dart';

final class DynamicNavigationBarState extends Equatable {
  // Item is the main buttons that change the page
  final int selectedItemIndex;

  // actions are the widgets that will emerge from the item
  final Map<int, List<PageInfo>> pageStackInfo;

  const DynamicNavigationBarState(
      {this.selectedItemIndex = 0, this.pageStackInfo = const {0: [], 1: [], 2: []}});

  @override
  List<Object?> get props => [selectedItemIndex, pageStackInfo];

  DynamicNavigationBarState copyWith({
    int? selectedItemIndex,
    Map<int, List<PageInfo>>? actions,
  }) {
    return DynamicNavigationBarState(
      selectedItemIndex: selectedItemIndex ?? this.selectedItemIndex,
      pageStackInfo: actions ?? this.pageStackInfo,
    );
  }
}

final class PageInfo {
  final List<Widget> actions;
  final BuildContext context;
  
  PageInfo({required this.context, this.actions = const []});
}

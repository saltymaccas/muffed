part of 'bloc.dart';

enum Pages { home, messages, inbox, profile }

extension PagesExtention on Pages {
  int index() {
    switch (this) {
      case Pages.home:
        return 0;
      case Pages.messages:
        return 1;
      case Pages.inbox:
        return 2;
      case Pages.profile:
        return 3;
    }
  }
}

final class DynamicNavigationBarState extends Equatable {
  ///
  const DynamicNavigationBarState({
    this.selectedItemIndex = 0,
    this.pageStackInfo = const {
      0: [],
      1: [],
      2: [],
      3: [],
    },
  });

  /// Item is the main buttons that change the page
  final int selectedItemIndex;

  /// actions are the widgets that will emerge from the item
  final Map<int, List<PageInfo>> pageStackInfo;

  @override
  List<Object?> get props => [selectedItemIndex, pageStackInfo];

  DynamicNavigationBarState copyWith({
    int? selectedItemIndex,
    Map<int, List<PageInfo>>? actions,
  }) {
    return DynamicNavigationBarState(
      selectedItemIndex: selectedItemIndex ?? this.selectedItemIndex,
      pageStackInfo: actions ?? pageStackInfo,
    );
  }
}

final class PageInfo {
  PageInfo({required this.context, this.actions = const []});

  final List<Widget> actions;
  final BuildContext context;
}

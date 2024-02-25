import 'package:flutter/material.dart';
import 'package:muffed/view/router/router.dart';

extension RouterExtentions on BuildContext {
  MNavigator get mNavigator => MNavigator.of(this);

  NavigatorState get navigator => Navigator.of(this);

  /// Removes the top page from the current branch
  void pop() {
    navigator.pop();
  }

  void maybePopRouteFromCurrentBranch() {
    mNavigator.state.currentBranch.key.currentState!.maybePop();
  }

  void popPageFromCurrentBranch() {
    mNavigator.popPageFromCurrentBranch();
  }

  /// Adds a page to the top of the current branch
  void pushPage(MPage<Object?> page) {
    mNavigator.pushPage(page);
  }

  /// Switches the current branch to the one with the given index
  void switchBranch(int newBranch) {
    mNavigator.switchBranch(newBranch);
  }
}

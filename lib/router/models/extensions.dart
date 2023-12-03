import 'package:flutter/material.dart';
import 'package:muffed/router/models/page.dart';

import '../navigator/navigator.dart';

extension RouterExtentions on BuildContext {
  MNavigator get navigator => MNavigator.of(this);

  /// Removes the top page from the current branch
  void pop() {
    navigator.pop();
  }

  /// Adds a page to the top of the current branch
  void push(MPage<Object?> page) {
    navigator.push(page);
  }

  /// Switches the current branch to the one with the given index
  void switchBranch(int newBranch) {
    navigator.switchBranch(newBranch);
  }
}

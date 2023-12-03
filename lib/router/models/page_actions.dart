import 'package:flutter/material.dart';

/// Holds a list of widgets that gets displayed to the appbar.
class PageActions with ChangeNotifier {
  PageActions(this.actions);

  List<Widget> actions;

  void setActions(List<Widget> actions) {
    this.actions = actions;
    notifyListeners();
  }
}

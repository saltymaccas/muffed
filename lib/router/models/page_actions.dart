import 'package:flutter/material.dart';

/// Holds a list of widgets that gets displayed to the naviagtion bar.
class PageActions extends ChangeNotifier {
  PageActions({this.actions});

  List<Widget>? actions;

  void setActions(List<Widget> items) {
    if (items != actions) {
      actions = items;
      notifyListeners();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:muffed/router/router.dart';
import 'package:provider/provider.dart';

/// Base class for creating pages which wraps a widget to be pushed onto the
/// page stack
///
/// The type T is the return type
abstract class MPage<T> extends Page<T> {
  MPage({PageActions? pageActions, super.key})
      : pageActions = pageActions ?? PageActions(null);

  /// An updatable list of widgets that gets displayed on the navigation bar
  /// when the user is on the page
  ///
  /// If the actions are null it will be assumed the page is not loaded and
  /// the navigation bar will continue displaying the previous page's actions
  final PageActions pageActions;

  /// build page content by overridng this function
  Widget build(BuildContext context);

  @override
  Route<T> createRoute(BuildContext context) {
    // // If the page actions are not set when route is created, it is assumed
    // // that the page does not want to have any actions
    // if (pageActions.actions == null) {
    //   pageActions.setActions([]);
    // }
    return MaterialPageRoute<T>(
      settings: this,
      builder: (context) => ChangeNotifierProvider.value(
        value: pageActions,
        child: Builder(builder: build),
      ),
    );
  }
}

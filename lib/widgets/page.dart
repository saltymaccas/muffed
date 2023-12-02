import 'package:flutter/material.dart';

/// Base class for creating pages which wraps a widget to be pushed onto the
/// page stack
///
/// The type T is the return type
abstract class MPage<T> extends Page<T> {
  /// build page content by overridng this function
  Widget build(BuildContext context);

  @override
  Route<T> createRoute(BuildContext context) {
    return MaterialPageRoute<T>(
      settings: this,
      builder: build,
    );
  }
}

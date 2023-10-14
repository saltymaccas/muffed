import 'package:flutter/material.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/components/snackbars.dart';

class MuffedPage extends StatelessWidget {
  /// Shows when loading and when an error occurs, meant to be wrapped around
  /// a page
  const MuffedPage({
    required this.child,
    required this.isLoading,
    this.error,
    this.showError = true,
    super.key,
  });

  final Widget child;

  /// Whether the page is loading
  final bool isLoading;

  /// The error
  final Object? error;

  /// Whether the error should show if there is one
  final bool showError;

  @override
  Widget build(BuildContext context) {
    if (showError && error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showErrorSnackBar(context, error: error);
      });
    }
    return MuffedPageLoadingIndicator(isLoading: isLoading, child: child);
  }
}

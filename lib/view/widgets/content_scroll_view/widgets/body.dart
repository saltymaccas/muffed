import 'package:flutter/material.dart';

enum ScrollViewBodyDisplayMode {
  loading,
  content,
  blank,
  failure,
}

class ContentScrollBodyView extends StatelessWidget {
  const ContentScrollBodyView({
    required this.contentSliver,
    this.displayMode = ScrollViewBodyDisplayMode.blank,
    super.key,
  });

  final Widget contentSliver;
  final ScrollViewBodyDisplayMode displayMode;

  @override
  Widget build(BuildContext context) {
    switch (displayMode) {
      case ScrollViewBodyDisplayMode.blank:
        return const SliverFillRemaining();
      case ScrollViewBodyDisplayMode.loading:
        return const SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      case ScrollViewBodyDisplayMode.content:
        return contentSliver;
      case ScrollViewBodyDisplayMode.failure:
        // TODO: improve
        return const Text('error occured');
    }
  }
}

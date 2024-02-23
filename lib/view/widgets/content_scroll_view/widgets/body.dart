import 'package:flutter/material.dart';

enum ScrollBodyMode {
  loading,
  content,
  noContent,
  blank,
  failure,
}

class ScrollBody extends StatelessWidget {
  const ScrollBody({
    required this.contentSliver,
    this.mode = ScrollBodyMode.blank,
    super.key,
  });

  final Widget contentSliver;
  final ScrollBodyMode mode;

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case ScrollBodyMode.blank:
        return const SliverFillRemaining();
      case ScrollBodyMode.loading:
        return const SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      case ScrollBodyMode.content:
        return contentSliver;
      case ScrollBodyMode.noContent:
        return const SliverFillRemaining(
          child: Center(child: Text('nothing to show')),
        );
      case ScrollBodyMode.failure:
        // TODO: improve
        return const SliverFillRemaining(
          child: Center(
            child: Text('error occured'),
          ),
        );
    }
  }
}

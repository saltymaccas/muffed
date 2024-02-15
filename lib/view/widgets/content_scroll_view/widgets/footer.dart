import 'package:flutter/material.dart';

enum ScrollViewFooterMode {
  loading,
  hidden,
  reachedEnd,
  failure,
}

class ContentScrollFooter extends StatelessWidget {
  const ContentScrollFooter({
    this.displayMode = ScrollViewFooterMode.hidden,
    super.key,
  });

  final ScrollViewFooterMode displayMode;

  double get height => 40;

  @override
  Widget build(BuildContext context) {
    switch (displayMode) {
      case ScrollViewFooterMode.hidden:
        return SliverToBoxAdapter(
          child: SizedBox(height: height),
        );
      case ScrollViewFooterMode.reachedEnd:

        // TODO: improve end reached message
        return SliverToBoxAdapter(
          child: SizedBox(
            height: height,
            child: const Center(child: Text('End Reached')),
          ),
        );
      case ScrollViewFooterMode.loading:
        return SliverToBoxAdapter(
          child: SizedBox(
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          ),
        );
      case ScrollViewFooterMode.failure:
        return SliverToBoxAdapter(
          child: SizedBox(
            height: height,
            // TODO: improve
            child: const Center(child: Text('error occured')),
          ),
        );
    }
  }
}

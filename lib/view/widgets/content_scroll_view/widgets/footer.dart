import 'package:flutter/material.dart';

enum ScrollFooterMode {
  loading,
  hidden,
  reachedEnd,
  failure,
}

class ScrollFooter extends StatelessWidget {
  const ScrollFooter({
    this.displayMode = ScrollFooterMode.hidden,
    super.key,
  });

  final ScrollFooterMode displayMode;

  double get height => 40;

  @override
  Widget build(BuildContext context) {
    switch (displayMode) {
      case ScrollFooterMode.hidden:
        return SliverToBoxAdapter(
          child: SizedBox(height: height),
        );
      case ScrollFooterMode.reachedEnd:

        // TODO: improve end reached message
        return SliverToBoxAdapter(
          child: SizedBox(
            height: height,
            child: const Center(child: Text('End Reached')),
          ),
        );
      case ScrollFooterMode.loading:
        return SliverToBoxAdapter(
          child: SizedBox(
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          ),
        );
      case ScrollFooterMode.failure:
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

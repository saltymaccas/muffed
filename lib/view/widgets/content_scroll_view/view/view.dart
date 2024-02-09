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

class PagedScrollView extends StatelessWidget {
  const PagedScrollView({
    this.body,
    this.footer,
    this.headerSlivers = const [],
    super.key,
  });

  final List<Widget> headerSlivers;
  final Widget? body;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        ...headerSlivers,
        if (body != null) body!,
        if (footer != null) footer!,
      ],
    );
  }
}

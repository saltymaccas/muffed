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

class PagedScrollView extends StatefulWidget {
  const PagedScrollView({
    this.body,
    this.footer,
    this.headerSlivers = const [],
    this.controller,
    this.loadMoreThreshold = 500,
    this.loadMoreCallback = _defaultLoadMoreCallback,
    super.key,
  });

  final List<Widget> headerSlivers;
  final Widget? body;
  final Widget? footer;
  final ScrollController? controller;

  final double loadMoreThreshold;
  final void Function() loadMoreCallback;

  static void _defaultLoadMoreCallback() {
    throw UnimplementedError();
  }

  @override
  State<PagedScrollView> createState() => _PagedScrollViewState();
}

class _PagedScrollViewState extends State<PagedScrollView> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = widget.controller ?? ScrollController();
    scrollController.addListener(scrollControllerListener);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(scrollControllerListener);
  }

  void scrollControllerListener() {
    final maxScrollExtent = scrollController.position.maxScrollExtent;
    final currentScrollExtent = scrollController.offset;

    if (currentScrollExtent < maxScrollExtent - widget.loadMoreThreshold) {
      widget.loadMoreCallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        ...widget.headerSlivers,
        if (widget.body != null) widget.body!,
        if (widget.footer != null) widget.footer!,
      ],
    );
  }
}

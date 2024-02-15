import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PagedScrollView extends StatefulWidget {
  const PagedScrollView({
    this.body,
    this.footer,
    this.headerSlivers = const [],
    this.controller,
    this.loadMoreThreshold = 500,
    this.loadMoreCallback = _defaultLoadMoreCallback,
    this.onRefresh = _defaultOnRefresh,
    this.indicateLoading = false,
    super.key,
  });

  final List<Widget> headerSlivers;
  final Widget? body;
  final Widget? footer;
  final ScrollController? controller;
  final bool indicateLoading;

  final double loadMoreThreshold;
  final void Function() loadMoreCallback;

  final Future<void> Function() onRefresh;

  static void _defaultLoadMoreCallback() {
    throw UnimplementedError();
  }

  static Future<void> _defaultOnRefresh() {
    return SynchronousFuture(null);
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
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: widget.onRefresh,
          child: CustomScrollView(
            cacheExtent: 1000,
            controller: scrollController,
            slivers: [
              ...widget.headerSlivers,
              if (widget.body != null) widget.body!,
              if (widget.footer != null) widget.footer!,
            ],
          ),
        ),
        if (widget.indicateLoading)
          const SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

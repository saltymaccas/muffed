import 'package:flutter/material.dart';

/// Display items retrieved from an API in a paginated scroll view
class ContentScrollView extends StatelessWidget {
  const ContentScrollView({
    required this.itemBuilder,
    required this.onPullDownRefresh,
    required this.onNearScrollEnd,
    bool? loadingMoreItems,
    bool? reachedEnd,
    List<Widget>? headerSlivers,
    super.key,
  })  : headerSlivers = headerSlivers ?? const [],
        loadingMoreItems = loadingMoreItems ?? false,
        reachedEnd = reachedEnd ?? false;

  /// Slivers that will go above the scroll
  final List<Widget> headerSlivers;

  final Widget? Function(BuildContext context, int index) itemBuilder;

  final Future<void> Function() onPullDownRefresh;

  final void Function() onNearScrollEnd;

  /// If loading more items to go on along with the already loaded items,
  /// a progress indicator will be shown at the bottom of the scroll
  final bool loadingMoreItems;

  /// If there are no more pages to be loaded
  final bool reachedEnd;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 500 &&
                scrollInfo.depth == 0) {
              onNearScrollEnd();
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: onPullDownRefresh,
            child: CustomScrollView(
              cacheExtent: 500,
              slivers: [
                ...headerSlivers,
                SliverList.builder(itemBuilder: itemBuilder),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: loadingMoreItems
                          ? const CircularProgressIndicator()
                          : reachedEnd
                              ? const Text('Reached End')
                              : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

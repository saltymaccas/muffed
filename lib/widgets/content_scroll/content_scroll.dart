import 'package:flutter/material.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/widgets/exception_widget.dart';

class ContentScroll<ContentType> extends StatelessWidget {
  const ContentScroll({
    required this.content,
    required this.onNearScrollEnd,
    required this.itemBuilder,
    required this.onPullDownRefresh,
    this.scrollController,
    this.nextPageError,
    this.onRetriedFromNextPageError,
    this.headerSlivers = const [],
    this.allPagesLoaded = false,
    this.isLoading = false,
    this.loadingNextPage = false,
    this.initialLoadError,
    this.onRetriedFromInitialLoadError,
    super.key,
  });

  final List<ContentType>? content;

  final ScrollController? scrollController;

  // Slivers that will be at the top of the scroll
  final List<Widget> headerSlivers;

  final bool allPagesLoaded;

  final bool isLoading;

  final bool loadingNextPage;

  final Object? initialLoadError;

  final Object? nextPageError;

  final void Function()? onRetriedFromNextPageError;

  final void Function()? onRetriedFromInitialLoadError;

  final Widget Function(BuildContext context, ContentType item) itemBuilder;

  final void Function() onNearScrollEnd;

  final Future<void> Function() onPullDownRefresh;

  bool get hasContent => content != null && content!.isNotEmpty;
  bool get hasError => initialLoadError != null;

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
              controller: scrollController,
              cacheExtent: 1000,
              slivers: [
                ...headerSlivers,
                if (isLoading && !hasContent)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (content != null &&
                    content!.isEmpty &&
                    !hasError &&
                    !isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: Text('Nothing to show'),
                    ),
                  ),
                if (!hasContent && hasError)
                  SliverFillRemaining(
                    child: ExceptionWidget(
                      exception: initialLoadError!,
                      retryCallback: onRetriedFromInitialLoadError,
                    ),
                  ),
                if (hasContent)
                  SliverList.builder(
                    itemBuilder: (context, index) {
                      return itemBuilder(context, content![index]);
                    },
                    itemCount: content!.length,
                  ),
                if (hasContent)
                  InfiniteContentScrollFooter(
                    loadingNextPage: loadingNextPage,
                    reachedEnd: allPagesLoaded,
                    retryLoadNextPageCallback: onRetriedFromNextPageError,
                    nextPageLoadError: nextPageError,
                  )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: (isLoading && hasContent)
                ? const LinearProgressIndicator()
                : const SizedBox(),
          ),
        ),
      ],
    );
  }
}

class InfiniteContentScrollFooter extends StatelessWidget {
  const InfiniteContentScrollFooter({
    this.loadingNextPage = false,
    this.reachedEnd = false,
    this.retryLoadNextPageCallback,
    this.nextPageLoadError,
    super.key,
  });

  final Object? nextPageLoadError;
  final void Function()? retryLoadNextPageCallback;
  final bool loadingNextPage;
  final bool reachedEnd;

  @override
  Widget build(BuildContext context) {
    late final Widget? child;

    if (nextPageLoadError != null) {
      child = ExceptionWidget(
        exception: nextPageLoadError!,
        retryCallback: retryLoadNextPageCallback,
      );
    } else if (loadingNextPage) {
      child = const CircularProgressIndicator();
    } else if (reachedEnd) {
      child = const Text('Reached End');
    } else {
      child = null;
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

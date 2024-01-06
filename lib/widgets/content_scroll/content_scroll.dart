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
    this.headerSlivers = const [],
    this.allPagesLoaded = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.onRetriedFromError,
    super.key,
  });

  final List<ContentType>? content;

  final ScrollController? scrollController;

  // Slivers that will be at the top of the scroll
  final List<Widget> headerSlivers;

  final bool allPagesLoaded;

  final bool isLoading;

  final bool isLoadingMore;

  // Will only be displayed if there is no content
  final Object? error;

  final void Function()? onRetriedFromError;

  final Widget Function(BuildContext context, ContentType item) itemBuilder;

  final void Function() onNearScrollEnd;

  final Future<void> Function() onPullDownRefresh;

  bool get hasContent => content != null && content!.isNotEmpty;
  bool get hasError => error != null;

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
                      exception: error!,
                      retryCallback: onRetriedFromError,
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
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 50,
                      child: Center(
                        child: isLoadingMore
                            ? const CircularProgressIndicator()
                            : allPagesLoaded
                                ? const Text('Reached End')
                                : null,
                      ),
                    ),
                  ),
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

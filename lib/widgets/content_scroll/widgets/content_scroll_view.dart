import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/widgets/content_scroll/content_scroll.dart';

/// Display items retrieved from an API in a paginated scroll view
class ContentScrollView<Data> extends StatelessWidget {
  const ContentScrollView({
    required this.builderDelegate,
    List<Widget>? headerSlivers,
    super.key,
  }) : headerSlivers = headerSlivers ?? const [];

  /// Slivers that will go above the scroll
  final List<Widget> headerSlivers;

  final ContentBuilderDelegate<Data> builderDelegate;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final bloc = context.read<ContentScrollBloc<Data>>();

        return BlocBuilder<ContentScrollBloc<Data>, ContentScrollState<Data>>(
          builder: (context, state) {
            return Stack(
              children: [
                NotificationListener(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 500 &&
                        scrollInfo.depth == 0) {
                      bloc.add(NearScrollEnd());
                    }
                    return true;
                  },
                  child: RefreshIndicator(
                    onRefresh: () async {
                      bloc.add(PullDownRefresh());
                      await bloc.stream.firstWhere(
                          (element) => element.isReloading == false,);
                    },
                    child: CustomScrollView(
                      key: ValueKey(state.loadedContentDelegate),
                      cacheExtent: 500,
                      slivers: [
                        ...headerSlivers,
                        if (state.status.isLoading)
                          const SliverFillRemaining(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (state.status.isFailure)
                          SliverFillRemaining(
                            child: Center(
                              child: ExceptionWidget(
                                exception: state.exception!,
                                retryFunction: () {
                                  bloc.add(LoadInitialItems());
                                },
                              ),
                            ),
                          )
                        else if (state.status.isSuccess)
                          builderDelegate.buildSliverList(
                            context,
                            state.content,
                          ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 50,
                            child: Center(
                              child: state.isLoadingMore
                                  ? const CircularProgressIndicator()
                                  : state.reachedEnd
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
                    child: state.isLoading
                        ? const LinearProgressIndicator()
                        : const SizedBox(),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

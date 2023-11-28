import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll_view/bloc/bloc.dart';
import 'package:muffed/widgets/error.dart';
import 'package:muffed/widgets/post_item/post_item.dart';
import 'package:muffed/widgets/snackbars.dart';

/// A function for retrieving content
typedef RetrieveContent = Future<List<Object>> Function({required int page});

/// displays any sort of content in a scroll view
class ContentScrollView extends StatelessWidget {
  const ContentScrollView({
    this.contentRetriever,
    this.headerSlivers = const [],
    this.contentScrollBloc,
    super.key,
  });

  /// The function used to retrieve the content
  final ContentRetriever? contentRetriever;

  /// Slivers that will go above the scroll
  final List<Widget> headerSlivers;

  /// If the bloc is already made it can be provided here
  final ContentScrollBloc? contentScrollBloc;

  @override
  Widget build(BuildContext context) {
    final widget = BlocListener<GlobalBloc, GlobalState>(
      // resets scroll view if account changes
      listenWhen: (previous, current) {
        return previous.requestUrlDifferent(current);
      },
      listener: (context, state) {
        context.read<ContentScrollBloc>().add(Initialise());
      },
      child: BlocConsumer<ContentScrollBloc, ContentScrollState>(
        listener: (context, state) {
          if (state.error != null) {
            showErrorSnackBar(context, error: state.error);
          }
        },
        builder: (context, state) {
          if (state.status == ContentScrollStatus.initial) {
            return CustomScrollView(
              slivers: [
                ...headerSlivers,
              ],
            );
          }

          if (state.status == ContentScrollStatus.loading) {
            return CustomScrollView(
              slivers: [
                ...headerSlivers,
                const SliverFillRemaining(
                  child: Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            );
          }

          if (state.status == ContentScrollStatus.failure) {
            return CustomScrollView(
              slivers: [
                ...headerSlivers,
                SliverFillRemaining(
                  child: ErrorComponentTransparent(error: state.error),
                ),
              ],
            );
          }

          // **** ON SUCCESS ****
          return Stack(
            children: [
              NotificationListener(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 500 &&
                      scrollInfo.depth == 0) {
                    context
                        .read<ContentScrollBloc>()
                        .add(ReachedNearEndOfScroll());
                  }
                  return true;
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<ContentScrollBloc>().add(PullDownRefresh());
                    await context
                        .read<ContentScrollBloc>()
                        .stream
                        .firstWhere((element) {
                      if (element.isRefreshing == false) {
                        return true;
                      }
                      return false;
                    });
                  },
                  child: CustomScrollView(
                    key: ValueKey(state.loadedRetrieveContent),
                    cacheExtent: 500,
                    slivers: [
                      ...headerSlivers,
                      SliverList.builder(
                        itemCount: state.content!.length,
                        itemBuilder: (context, index) {
                          final item = state.content![index];

                          if (item is LemmyPost) {
                            return PostItem(
                              post: item,
                              displayType: PostDisplayType.list,
                            );
                          } else {
                            return const Text('could not display item');
                          }
                        },
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 50,
                          child: Center(
                            child: (state.isLoadingMore)
                                ? const CircularProgressIndicator()
                                : (state.reachedEnd)
                                    ? Text('Reached End')
                                    : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state.isLoading)
                const Align(
                  alignment: Alignment.topCenter,
                  child: LinearProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );

    if (contentScrollBloc == null) {
      return BlocProvider(
        create: (context) => ContentScrollBloc(
          retrieveContent: contentRetriever!,
        )..add(Initialise()),
        child: widget,
      );
    } else {
      return BlocProvider.value(
        value: contentScrollBloc!,
        child: widget,
      );
    }
  }
}

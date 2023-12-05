import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';
import 'package:muffed/widgets/error.dart';
import 'package:muffed/widgets/post/post.dart';
import 'package:muffed/widgets/snackbars.dart';

final _log = Logger('ContentScrollView');

typedef ItemBuilder = Widget? Function(BuildContext, int, List<Object> content);

/// Display items retrieved from an API in a paginated scroll view
class ContentScrollView extends StatelessWidget {
  const ContentScrollView({
    this.contentRetriever,
    this.itemBuilder,
    List<Widget>? headerSlivers,
    super.key,
  }) : headerSlivers = headerSlivers ?? const [];

  /// Slivers that will go above the scroll
  final List<Widget> headerSlivers;

  /// The function used to build the items
  final ItemBuilder? itemBuilder;

  final ContentRetriever? contentRetriever;

  @override
  Widget build(BuildContext context) {
    late ContentScrollBloc contentScrollBloc;

    try {
      contentScrollBloc = BlocProvider.of<ContentScrollBloc>(context);
      _log.info('Found bloc in context, using it');
    } catch (err) {
      contentScrollBloc = ContentScrollBloc(contentRetriever: contentRetriever!)
        ..add(Initialise());
      _log.info('No bloc found in context, creating new one');
    }

    return BlocProvider.value(
      value: contentScrollBloc,
      child: BlocListener<GlobalBloc, GlobalState>(
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
                            if (itemBuilder != null) {
                              return itemBuilder!(
                                  context, index, state.content!);
                            }

                            final item = state.content![index];

                            if (item is LemmyPost) {
                              return PostWidget(
                                post: item,
                                displayType: PostDisplayType.list,
                              );
                            } else {
                              return const Text('Item type did not match any');
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
                  const SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: LinearProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

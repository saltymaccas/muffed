import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/interfaces/lemmy/lemmy.dart';
import 'package:muffed/interfaces/lemmy/models/models.dart';
import 'package:muffed/widgets/content_scroll/content_scroll.dart';
import 'package:muffed/widgets/exception_snackbar.dart';
import 'package:muffed/widgets/lemmy_post_scroll/bloc/bloc.dart';
import 'package:muffed/widgets/post/view/post.dart';

class LemmyPostScroll extends StatefulWidget {
  const LemmyPostScroll({required this.sortType, super.key});

  final SortType sortType;

  @override
  State<LemmyPostScroll> createState() => _LemmyPostScrollState();
}

class _LemmyPostScrollState extends State<LemmyPostScroll> {
  late final ScrollController scrollController;
  late final LemmyPostScrollBloc postScrollBloc;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    postScrollBloc =
        LemmyPostScrollBloc(lem: context.lemmy, initialSort: widget.sortType)
          ..add(Initialised());
  }

  @override
  void didUpdateWidget(covariant LemmyPostScroll oldWidget) {
    if (oldWidget.sortType != widget.sortType) {
      postScrollBloc.add(SortChanged(widget.sortType));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    scrollController.dispose();
    postScrollBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: postScrollBloc,
      child: Builder(
        builder: (context) {
          final homeBloc = context.read<LemmyPostScrollBloc>();
          return MultiBlocListener(
            listeners: [
              // jump scroll to top when pages have been replaced
              BlocListener<LemmyPostScrollBloc, LemmyPostScrollState>(
                listenWhen: (previous, current) =>
                    previous.loadedSort != current.loadedSort,
                listener: (context, state) {
                  scrollController.jumpTo(0);
                },
              ),
              BlocListener<LemmyPostScrollBloc, LemmyPostScrollState>(
                listener: (context, state) {
                  if (state.status.isFailure) {
                    showExceptionSnackBar(
                      context: context,
                      exception: state.exception,
                    );
                  }
                },
              ),
            ],
            child: BlocBuilder<LemmyPostScrollBloc, LemmyPostScrollState>(
              builder: (context, state) {
                return Scaffold(
                  body: ContentScroll<PostView>(
                    scrollController: scrollController,
                    content: state.posts,
                    onNearScrollEnd: () => homeBloc.add(ReachedNearScrollEnd()),
                    itemBuilder: (context, item) => PostWidget(
                      post: item,
                    ),
                    onPullDownRefresh: () async {
                      context.read<LemmyPostScrollBloc>().add(PullDownReload());
                      await homeBloc.stream.firstWhere((state) {
                        return state.status != HomeStateStatus.reloading;
                      });
                    },
                    allPagesLoaded: state.loadedAllPages,
                    initialLoadError:
                        !state.hasLoadedContent ? state.exception : null,
                    onRetriedFromInitialLoadError: () =>
                        homeBloc.add(Initialised()),
                    isLoading: state.status.isLoading,
                    loadingNextPage: state.status.isLoadingMore,
                    nextPageError: state.status.isFailure &&
                            state.lastEvent is ReachedNearScrollEnd
                        ? state.exception
                        : null,
                    onRetriedFromNextPageError: () => homeBloc.add(Retry()),
                    headerSlivers: [],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

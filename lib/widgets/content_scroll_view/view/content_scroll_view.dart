import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/community/community.dart';
import 'package:muffed/pages/user_screen/user.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/comment/comment.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';
import 'package:muffed/widgets/error.dart';
import 'package:muffed/widgets/post/post.dart';
import 'package:muffed/widgets/snackbars.dart';

final _log = Logger('ContentScrollView');

typedef ContentSliverListBuilder = Widget Function(
    BuildContext context, List<Object> content);

typedef ContentItemBuilder = Widget Function(
    BuildContext context, int index, Object item);

/// Display items retrieved from an API in a paginated scroll view
class ContentScrollView extends StatelessWidget {
  ContentScrollView({
    required ContentItemBuilder itemBuilder,
    this.contentRetriever,
    List<Widget>? headerSlivers,
    super.key,
  })  : headerSlivers = headerSlivers ?? const [],
        sliverListBuilder = ((BuildContext context, List<Object> content) {
          return SliverList.builder(
            itemCount: content.length,
            itemBuilder: (context, index) =>
                itemBuilder(context, index, content[index]),
          );
        });

  ContentScrollView.commentTree({
    LemmyCommentSortType sortType = LemmyCommentSortType.hot,
    this.contentRetriever,
    List<Widget>? headerSlivers,
    super.key,
  })  : headerSlivers = headerSlivers ?? const [],
        sliverListBuilder = ((BuildContext context, List<Object> content) {
          return commentTreeListBuilder(context, content, sortType);
        });

  ContentScrollView.posts({
    this.contentRetriever,
    List<Widget>? headerSlivers,
    super.key,
  })  : headerSlivers = headerSlivers ?? const [],
        sliverListBuilder = itemBuilderToSliverListBuilder(
            (context, index, item) => PostWidget(post: item as LemmyPost));

  ContentScrollView.communities({
    this.contentRetriever,
    List<Widget>? headerSlivers,
    super.key,
  })  : headerSlivers = headerSlivers ?? const [],
        sliverListBuilder = itemBuilderToSliverListBuilder(
          (context, index, item) => CommunityListTile(item as LemmyCommunity),
        );

  ContentScrollView.cardComments({
    this.contentRetriever,
    List<Widget>? headerSlivers,
    super.key,
  })  : headerSlivers = headerSlivers ?? const [],
        sliverListBuilder = itemBuilderToSliverListBuilder(
          (context, index, item) =>
              CommentWidget.card(comment: item as LemmyComment),
        );

  ContentScrollView.users(
      {this.contentRetriever, List<Widget>? headerSlivers, super.key})
      : headerSlivers = headerSlivers ?? const [],
        sliverListBuilder = itemBuilderToSliverListBuilder(
          (context, index, item) => UserListTile(person: item as LemmyUser),
        );

  static Widget commentTreeListBuilder(BuildContext context,
      List<Object> content, LemmyCommentSortType sortType) {
    if (content is! List<LemmyComment>) {
      throw Exception('Content is not a list of comments');
    }

    final organisedComments = organiseCommentsWithChildren(0, content);

    return SliverList.builder(
      itemCount: organisedComments.length,
      itemBuilder: (context, index) {
        final baseComment = organisedComments.keys.elementAt(index);
        final childComments = organisedComments[baseComment]!;

        return CommentWidget.tree(
          sortType: sortType,
          comment: baseComment,
          children: childComments,
        );
      },
    );
  }

  static ContentSliverListBuilder itemBuilderToSliverListBuilder(
      ContentItemBuilder itemBuilder) {
    return (context, content) {
      return SliverList.builder(
        itemCount: content.length,
        itemBuilder: (context, index) {
          return itemBuilder(context, index, content[index]);
        },
      );
    };
  }

  /// Slivers that will go above the scroll
  final List<Widget> headerSlivers;

  final ContentRetriever? contentRetriever;

  final ContentSliverListBuilder sliverListBuilder;

  @override
  Widget build(BuildContext context) {
    late bool blocAlreadyExists;

    try {
      BlocProvider.of<ContentScrollBloc>(context);
      _log.info('Found bloc in context, using it');
      blocAlreadyExists = true;
    } catch (err) {
      _log.info('No bloc found in context, creating new one');
      blocAlreadyExists = false;
    }

    if (blocAlreadyExists) {
      return buildView(context);
    } else {
      return BlocProvider(
        create: (context) =>
            ContentScrollBloc(contentRetriever: contentRetriever!)
              ..add(Initialise()),
        child: buildView(context),
      );
    }
  }

  Widget buildView(BuildContext context) {
    return BlocListener<GlobalBloc, GlobalState>(
      // resets scroll view if account changes
      listenWhen: (previous, current) {
        return previous.requestUrlDifferent(current);
      },
      listener: (context, state) {
        context.read<ContentScrollBloc>().add(Initialise());
      },
      child: BlocConsumer<ContentScrollBloc, ContentScrollState>(
        listener: (context, state) {
          if (state.exception != null) {
            showErrorSnackBar(context, error: state.exception);
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
                  child: ErrorComponentTransparent(error: state.exception),
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
                      scrollInfo.depth == 0 &&
                      state.content.isNotEmpty) {
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
                      if (state.content.isNotEmpty)
                        sliverListBuilder(context, state.content)
                      else
                        const SliverFillRemaining(
                          child: Center(child: Text('nothing to show')),
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
    );
  }
}

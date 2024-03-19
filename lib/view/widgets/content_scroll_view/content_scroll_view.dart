import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/widgets/comment_item/comment_item.dart';
import 'package:muffed/view/widgets/content_scroll_view/bloc/bloc.dart';
import 'package:muffed/view/widgets/content_scroll_view/content_scroll_view.dart';
import 'package:muffed/view/widgets/content_scroll_view/view/view.dart';
import 'package:muffed/view/widgets/post/post_item.dart';

export 'widgets/widgets.dart';
export 'view/view.dart';

/// A function for retrieving content
typedef RetrieveContent = Future<List<Object>> Function({required int page});

abstract class ContentRetriever {
  const ContentRetriever();

  Future<List<Object>> call({required int page});
}

class ContentScrollSliver extends StatelessWidget {
  final List<Object> content;

  const ContentScrollSliver({List<Object>? content, super.key})
      : content = content ?? const [];

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: content.length,
      itemBuilder: (context, index) {
        final item = content[index];

        if (item is PostView) {
          return PostWidget(
            post: item,
          );
        } else if (item is LemmyComment) {
          return CommentItem(
            comment: item,
            displayMode: CommentItemDisplayMode.single,
          );
        } else {
          return const Text('could not display item');
        }
      },
    );
  }
}

/// Display items retrieved from an API in a paginated scroll view
class ContentScrollView extends StatefulWidget {
  /// The function used to retrieve the content
  final ContentRetriever? contentRetriever;

  /// Slivers that will go above the scroll
  final List<Widget> headerSlivers;

  /// If the bloc is already made it can be provided here
  final ContentScrollBloc? contentScrollBloc;

  /// How any comments will be displayed
  final CommentItemDisplayMode commentItemDisplayMode;

  const ContentScrollView({
    this.contentRetriever,
    this.headerSlivers = const [],
    this.contentScrollBloc,
    this.commentItemDisplayMode = CommentItemDisplayMode.single,
    super.key,
  });

  @override
  State<ContentScrollView> createState() => _ContentScrollViewState();
}

class _ContentScrollViewState extends State<ContentScrollView> {
  late final ContentScrollBloc bloc;
  late ContentScrollState state;

  void blocListener(ContentScrollState element) {
    setState(() {
      state = element;
    });
  }

  @override
  Widget build(BuildContext context) {
    var footerDisplayMode = ScrollFooterMode.hidden;
    var bodyDisplayMode = ScrollBodyMode.blank;

    if (state.reachedEnd) {
      footerDisplayMode = ScrollFooterMode.reachedEnd;
    } else if (state.isLoading) {
      footerDisplayMode = ScrollFooterMode.loading;
    }

    switch (state.status) {
      case ContentScrollStatus.initial:
        bodyDisplayMode = ScrollBodyMode.blank;
      case ContentScrollStatus.loading:
        bodyDisplayMode = ScrollBodyMode.loading;
      case ContentScrollStatus.success:
        bodyDisplayMode = ScrollBodyMode.content;
      case ContentScrollStatus.failure:
        bodyDisplayMode = ScrollBodyMode.failure;
    }

    return PagedScrollView(
      headerSlivers: widget.headerSlivers,
      indicateLoading: state.isLoading,
      body: ScrollBody(
        mode: bodyDisplayMode,
        contentSliver: ContentScrollSliver(content: state.content),
      ),
      footer: ScrollFooter(
        displayMode: footerDisplayMode,
      ),
      loadMoreCallback: () => bloc.add(ReachedNearEndOfScroll()),
      onRefresh: () async {
        bloc.add(PullDownRefresh());
        await bloc.stream.firstWhere((element) => !element.isRefreshing);
        return;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    bloc = widget.contentScrollBloc ??
        ContentScrollBloc(retrieveContent: widget.contentRetriever!)
      ..add(Initialise());

    state = bloc.state;

    bloc.stream.listen(blocListener);
  }
}

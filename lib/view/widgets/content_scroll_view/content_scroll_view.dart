import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/widgets/comment_item/comment_item.dart';
import 'package:muffed/view/widgets/content_scroll_view/bloc/bloc.dart';
import 'package:muffed/view/widgets/content_scroll_view/view/view.dart';
import 'package:muffed/view/widgets/post_item/post_item.dart';

abstract class ContentRetriever {
  const ContentRetriever();

  Future<List<Object>> call({required int page});
}

/// A function for retrieving content
typedef RetrieveContent = Future<List<Object>> Function({required int page});

/// Display items retrieved from an API in a paginated scroll view
class ContentScrollView extends StatefulWidget {
  const ContentScrollView({
    this.contentRetriever,
    this.headerSlivers = const [],
    this.contentScrollBloc,
    this.commentItemDisplayMode = CommentItemDisplayMode.single,
    super.key,
  });

  /// The function used to retrieve the content
  final ContentRetriever? contentRetriever;

  /// Slivers that will go above the scroll
  final List<Widget> headerSlivers;

  /// If the bloc is already made it can be provided here
  final ContentScrollBloc? contentScrollBloc;

  /// How any comments will be displayed
  final CommentItemDisplayMode commentItemDisplayMode;

  @override
  State<ContentScrollView> createState() => _ContentScrollViewState();
}

class _ContentScrollViewState extends State<ContentScrollView> {
  late final ContentScrollBloc bloc;
  late ContentScrollState state;

  @override
  void initState() {
    super.initState();
    bloc = widget.contentScrollBloc ??
        ContentScrollBloc(retrieveContent: widget.contentRetriever!)
      ..add(Initialise());

    state = bloc.state;

    bloc.stream.listen(blocListener);
  }

  void blocListener(ContentScrollState element) {
    setState(() {
      state = element;
    });
  }

  @override
  Widget build(BuildContext context) {
    var footerDisplayMode = ScrollViewFooterMode.hidden;
    var bodyDisplayMode = ScrollViewBodyDisplayMode.blank;

    if (state.reachedEnd) {
      footerDisplayMode = ScrollViewFooterMode.reachedEnd;
    } else if (state.isLoading) {
      footerDisplayMode = ScrollViewFooterMode.loading;
    }

    switch (state.status) {
      case ContentScrollStatus.initial:
        bodyDisplayMode = ScrollViewBodyDisplayMode.blank;
      case ContentScrollStatus.loading:
        bodyDisplayMode = ScrollViewBodyDisplayMode.loading;
      case ContentScrollStatus.success:
        bodyDisplayMode = ScrollViewBodyDisplayMode.content;
      case ContentScrollStatus.failure:
        bodyDisplayMode = ScrollViewBodyDisplayMode.failure;
    }

    return PagedScrollView(
      headerSlivers: widget.headerSlivers,
      indicateLoading: state.isLoading,
      body: ContentScrollBodyView(
        displayMode: bodyDisplayMode,
        contentSliver: ContentScrollSliver(content: state.content),
      ),
      footer: ContentScrollFooter(
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
}

class ContentScrollSliver extends StatelessWidget {
  const ContentScrollSliver({List<Object>? content, super.key})
      : content = content ?? const [];

  final List<Object> content;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: content.length,
      itemBuilder: (context, index) {
        final item = content[index];

        if (item is LemmyPost) {
          return PostItem(
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/global_state/bloc.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/pages/create_post_screen/bloc/bloc.dart';
import 'package:muffed/view/widgets/comment_item/comment_item.dart';
import 'package:muffed/view/widgets/content_scroll_view/bloc/bloc.dart';
import 'package:muffed/view/widgets/content_scroll_view/view/view.dart';
import 'package:muffed/view/widgets/error.dart';
import 'package:muffed/view/widgets/post_item/post_item.dart';
import 'package:muffed/view/widgets/snackbars.dart';

abstract class ContentRetriever {
  const ContentRetriever();

  Future<List<Object>> call({required int page});
}

/// A function for retrieving content
typedef RetrieveContent = Future<List<Object>> Function({required int page});

/// Display items retrieved from an API in a paginated scroll view
class ContentScrollView extends StatelessWidget {
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

  Widget contentSliver(List<Object>? content) {
    final _content = content ?? [];
    return SliverList.builder(
      itemCount: _content.length,
      itemBuilder: (context, index) {
        final item = _content[index];

        if (item is LemmyPost) {
          return PostItem(
            post: item,
          );
        } else if (item is LemmyComment) {
          return CommentItem(
            comment: item,
            displayMode: commentItemDisplayMode,
          );
        } else {
          return const Text('could not display item');
        }
      },
    );
  }

  Widget _contentScrollView(ContentScrollBloc bloc, ContentScrollState state) {
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
      headerSlivers: headerSlivers,
      body: ContentScrollBodyView(
        displayMode: bodyDisplayMode,
        contentSliver: contentSliver(state.content),
      ),
      footer: ContentScrollFooter(
        displayMode: footerDisplayMode,
      ),
      loadMoreCallback: () => bloc.add(ReachedNearEndOfScroll()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (contentScrollBloc == null) {
      return BlocProvider(
        create: (context) =>
            ContentScrollBloc(retrieveContent: contentRetriever!)
              ..add(Initialise()),
        child: BlocBuilder<ContentScrollBloc, ContentScrollState>(
          builder: (context, state) {
            return _contentScrollView(context.read<ContentScrollBloc>(), state);
          },
        ),
      );
    } else {
      return BlocProvider.value(
        value: contentScrollBloc!..add(Initialise()),
        child: BlocBuilder<ContentScrollBloc, ContentScrollState>(
          builder: (context, state) {
            return _contentScrollView(context.read<ContentScrollBloc>(), state);
          },
        ),
      );
    }
  }
}

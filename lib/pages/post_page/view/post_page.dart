import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/post_page/post_page.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/widgets/comment/comment.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';
import 'package:muffed/widgets/popup_menu/popup_menu.dart';
import 'package:muffed/widgets/post/post.dart';

class PostPage extends MPage<void> {
  PostPage({int? postId, this.post, this.postBloc})
      : assert(
          post != null ||
              postId != null ||
              postBloc != null && postBloc.post != null,
          'No post defined',
        ),
        postId = postId ?? post?.id ?? postBloc!.post!.id,
        super(pageActions: PageActions([]));

  final int postId;
  final LemmyPost? post;
  final PostBloc? postBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ContentScrollBloc(
            contentRetriever: CommentRetriever(
              repo: context.read<ServerRepo>(),
              postId: postId,
            ),
          )..add(Initialise()),
        ),
        if (postBloc != null)
          BlocProvider.value(value: postBloc!)
        else
          BlocProvider(
            create: (context) => PostBloc(
              repo: context.read<ServerRepo>(),
              globalBloc: context.read<GlobalBloc>(),
            )..add(Initialize()),
          ),
      ],
      child: Builder(
        builder: (context) {
          final contentScrollBloc = context.read<ContentScrollBloc>();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            pageActions!.setActions(
              [
                BlocBuilder<ContentScrollBloc, ContentScrollState>(
                  bloc: contentScrollBloc,
                  builder: (context, state) {
                    final retrieveContent =
                        state.retrieveContent as CommentRetriever;

                    void changeSortType(LemmyCommentSortType sortType) {
                      contentScrollBloc.add(
                        RetrieveContentMethodChanged(
                          retrieveContent.copyWith(sortType: sortType),
                        ),
                      );
                    }

                    return MuffedPopupMenuButton(
                      icon: const Icon(Icons.sort),
                      visualDensity: VisualDensity.compact,
                      selectedValue: retrieveContent.sortType,
                      items: [
                        MuffedPopupMenuItem(
                          title: 'Hot',
                          icon: const Icon(Icons.local_fire_department),
                          value: LemmyCommentSortType.hot,
                          onTap: () => changeSortType(LemmyCommentSortType.hot),
                        ),
                        MuffedPopupMenuItem(
                          title: 'Top',
                          icon: const Icon(Icons.military_tech),
                          value: LemmyCommentSortType.top,
                          onTap: () => changeSortType(LemmyCommentSortType.top),
                        ),
                        MuffedPopupMenuItem(
                          title: 'New',
                          icon: const Icon(Icons.auto_awesome),
                          value: LemmyCommentSortType.latest,
                          onTap: () =>
                              changeSortType(LemmyCommentSortType.latest),
                        ),
                        MuffedPopupMenuItem(
                          title: 'Old',
                          icon: const Icon(Icons.elderly),
                          value: LemmyCommentSortType.old,
                          onTap: () => changeSortType(LemmyCommentSortType.old),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          });
          return const _PostView();
        },
      ),
    );
  }
}

/// Displays a screen that shows the post on top and the comments under
class _PostView extends StatelessWidget {
  const _PostView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentScrollView(
        headerSlivers: [
          const SliverAppBar(
            title: Text('Comments'),
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: PostWidget(
              displayType: PostDisplayType.comments,
              bloc: BlocProvider.of<PostBloc>(context),
              form: PostViewForm.card,
            ),
          ),
        ],
        itemBuilder: (context, index, content) {
          // Iterates through the comments until it finds a base comment,
          // Iterates through the children again gathering all the descendants
          // of the comment and returns the comment widget

          int level0Index = 0;
          for (final item in content) {
            if (item is! LemmyComment) continue;
            if (item.level == 0) {
              // makes sure it does not process a comment multiple times
              if (level0Index == index) {
                final List<LemmyComment> children = [];
                for (final item2 in content) {
                  if (item2 is! LemmyComment) continue;
                  if (item2.path.isNotEmpty && item2.path.first == item.id) {
                    children.add(item2);
                  }
                }
                return CommentWidget(
                  comment: item,
                  children: children,
                );
              }
              level0Index++;
            }
          }
          return null;
        },
      ),
    );
  }
}

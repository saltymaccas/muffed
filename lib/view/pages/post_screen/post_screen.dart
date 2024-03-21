import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemmy_api_client/v3.dart';

import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/pages/post_screen/bloc/bloc.dart';
import 'package:muffed/view/router/models/page.dart';
import 'package:muffed/view/widgets/comment/comment.dart';
import 'package:muffed/view/widgets/content_scroll_view/content_scroll_view.dart';
import 'package:muffed/view/widgets/post/bloc/bloc.dart';
import 'package:muffed/view/widgets/post/post_item.dart';

class PostPage extends MPage<void> {
  PostPage({this.post, this.postId, this.postBloc});

  final PostView? post;
  final int? postId;
  final PostBloc? postBloc;

  @override
  Widget build(BuildContext context) {
    return PostScreen(
      post: post,
      postId: postId,
      postBloc: postBloc,
    );
  }
}

/// Displays a screen that shows the post on top and the comments under
class PostScreen extends StatefulWidget {
  /// Displays a screen that shows the post on top and the comments under
  const PostScreen({
    this.post,
    this.postId,
    this.postBloc,
    super.key,
  }) : assert(
          post != null || postId != null,
          'No post provided',
        );

  /// The post that should be shown
  final PostView? post;

  final int? postId;

  /// If a post bloc already exits for the post it should be passed in here
  final PostBloc? postBloc;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late final PostBloc postBloc;
  late final CommentScrollBloc commentScrollBloc;

  @override
  void initState() {
    super.initState();
    final lem = context.read<ServerRepo>().lemmyRepo;

    postBloc = widget.postBloc ??
        PostBloc(post: widget.post, postId: widget.postId, lemmyRepo: lem)
      ..add(Initialised());

    commentScrollBloc = CommentScrollBloc(
      postId: widget.post?.post.id ?? widget.postId!,
      lemmyRepo: lem,
    )..add(CommentScrollInitialised());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentScrollBloc, CommentScrollState>(
      bloc: commentScrollBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: PagedScroll(
            headerSlivers: [
              SliverToBoxAdapter(
                child: PostWidget(bloc: postBloc),
              ),
            ],
            status: state.status,
            items: state.comments,
            itemBuilder: (context, item) {
              return CommentTreeWidget(
                commentTree: item,
                sortType: state.sort,
              );
            },
            seperatorBuilder: (context, index) => const Divider(),
          ),
        );
      },
    );
  }
}

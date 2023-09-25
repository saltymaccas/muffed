import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/content_view/post_item/bloc/bloc.dart';
import 'package:muffed/repo/server_repo.dart';

import 'post_view_modes/post_view_modes.dart';

enum PostViewMode { card }

class PostItem extends StatelessWidget {
  ///
  const PostItem({
    required this.post,
    this.type = PostViewMode.card,
    this.openOnTap = true,
    this.limitHeight = false,
    super.key,
  });

  final LemmyPost post;
  final PostViewMode type;
  final bool openOnTap;
  final bool limitHeight;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostItemBloc(post: post, repo: context.read<ServerRepo>()),
      child: BlocBuilder<PostItemBloc, PostItemState>(
        builder: (context, state) {
          switch (type) {
            case PostViewMode.card:
              return CardLemmyPostItem(
                state.post,
                openOnTap: openOnTap,
                limitContentHeight: limitHeight,
              );
          }
        },
      ),
    );
  }
}

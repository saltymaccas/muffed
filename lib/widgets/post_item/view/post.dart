import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/post_item/post_item.dart';

/// Displays a post
class PostWidget extends StatelessWidget {
  const PostWidget({
    this.bloc,
    this.form,
    this.displayType,
    this.post,
    this.postId,
    super.key,
  }) : assert(
          post != null || postId != null || bloc != null,
          'No post defined',
        );

  final PostItemBloc? bloc;
  final PostViewForm? form;
  final PostDisplayType? displayType;
  final LemmyPost? post;
  final int? postId;

  @override
  Widget build(BuildContext context) {
    if (bloc != null) {
      return BlocProvider.value(
        value: bloc!,
        child: PostView(
          form: form,
          displayType: displayType,
        ),
      );
    } else {
      return BlocProvider(
        create: (context) => PostItemBloc(
            repo: context.read<ServerRepo>(),
            globalBloc: context.read<GlobalBloc>(),
            post: post,
            postId: postId),
        child: PostView(form: form, displayType: displayType),
      );
    }
  }
}

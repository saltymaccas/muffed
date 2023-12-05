import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/pages/post_page/post_page.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/widgets/error.dart';
import 'package:muffed/widgets/post/post.dart';

/// A widget that displays a post, The form the post is displayed in can be
/// changed with [PostViewForm]
class PostView extends StatefulWidget {
  const PostView({
    PostViewForm? form,
    PostDisplayType? displayType,
    super.key,
  })  : form = form ?? PostViewForm.card,
        displayType = displayType ?? PostDisplayType.list;

  final PostViewForm form;
  final PostDisplayType displayType;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state.status == PostStatus.initial) {
          return const SizedBox();
        }
        if (state.status == PostStatus.loading) {
          switch (widget.form) {
            case PostViewForm.card:
              return PostViewCard.loading(
                displayType: widget.displayType,
              );
          }
        }
        if (state.status == PostStatus.failure) {
          return ErrorComponentTransparent(
            error: state.error,
            retryFunction: () {
              context.read<PostBloc>().add(Initialize());
            },
          );
        }
        if (state.status == PostStatus.success) {
          switch (widget.form) {
            case PostViewForm.card:
              return PostViewCard(
                state.post!,
                displayType: widget.displayType,
                openPost: () {
                  context.push(
                    PostPage(
                      postBloc: context.read<PostBloc>(),
                      post: state.post,
                    ),
                  );
                },
              );
          }
        }
        return const Text('null');
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

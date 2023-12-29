import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/pages/community/community.dart';
import 'package:muffed/pages/post_page/post_page.dart';
import 'package:muffed/pages/user/user.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/theme/models/extentions.dart';
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

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
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
          return ExceptionWidget(
            exception: state.exception!,
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
                openPostCallback: () {
                  context.pushPage(
                    PostPage(
                      postBloc: context.read<PostBloc>(),
                      post: state.post,
                    ),
                  );
                },
                openMoreMenuCallback: () {
                  _openMoreMenu(
                    context: context,
                    bloc: context.read<PostBloc>(),
                  );
                },
              );
          }
        }
        return const Text('null');
      },
    );
  }
}

void _openMoreMenu({required BuildContext context, required PostBloc bloc}) {
  showModalBottomSheet<void>(
    useRootNavigator: true,
    clipBehavior: Clip.hardEdge,
    context: context,
    builder: (context) => BlocProvider.value(
      value: bloc,
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: state.post!.saved
                    ? const Text('Unsave post')
                    : const Text('Save post'),
                leading: AnimatedCrossFade(
                  crossFadeState: state.post!.saved
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: context.animationTheme.switchInDurationSmall,
                  reverseDuration:
                      context.animationTheme.switchOutDurationSmall,
                  firstCurve: context.animationTheme.switchCurveSmall,
                  secondCurve: context.animationTheme.switchCurveSmall,
                  sizeCurve: context.animationTheme.switchCurveSmall,
                  firstChild: Icon(
                    Icons.bookmark,
                    color: context.colorScheme.primary,
                  ),
                  secondChild: const Icon(Icons.bookmark_outline),
                ),
                onTap: () => context.read<PostBloc>().add(SavePostToggled()),
              ),
              ListTile(
                title: const Text('Go to community'),
                leading: const Icon(Icons.group),
                onTap: () {
                  context
                    ..pop()
                    ..pushPage(
                      CommunityPage(
                        communityId: state.post!.communityId,
                        communityName: state.post!.communityName,
                      ),
                    );
                },
              ),
              ListTile(
                title: const Text('Go to user'),
                leading: const Icon(Icons.person),
                onTap: () => context
                  ..pop()
                  ..pushPage(
                    UserPage(userId: state.post!.creatorId),
                  ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

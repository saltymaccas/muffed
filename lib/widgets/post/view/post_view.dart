import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/db/db.dart';
import 'package:muffed/pages/community/community.dart';
import 'package:muffed/pages/post_page/post_page.dart';
import 'package:muffed/pages/user/user.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/theme/models/extentions.dart';
import 'package:muffed/widgets/post/post.dart';

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
          'No post defined in PostWidget constructor',
        );

  final PostBloc? bloc;
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
        create: (context) => PostBloc(
          repo: context.read<ServerRepo>(),
          globalBloc: context.read<DB>(),
          post: post,
          postId: postId,
        )..add(
            Initialize(),
          ),
        child: PostView(form: form, displayType: displayType),
      );
    }
  }
}

/// A widget that displays a post, The form the post is displayed in can be
/// changed with [PostViewForm]
class PostView extends StatelessWidget {
  const PostView({
    PostViewForm? form,
    PostDisplayType? displayType,
    super.key,
  })  : form = form ?? PostViewForm.card,
        displayType = displayType ?? PostDisplayType.list;

  final PostViewForm form;
  final PostDisplayType displayType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state.status == PostStatus.initial) {
          // size should stay the same even on initial so scroll views can
          // correctly calcuate its size
          switch (form) {
            case PostViewForm.card:
              return Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: false,
                child: PostViewCard.loading(
                  displayType: displayType,
                  placeHolderData: state.post,
                ),
              );
          }
        }
        if (state.status == PostStatus.loading) {
          switch (form) {
            case PostViewForm.card:
              return PostViewCard.loading(
                displayType: displayType,
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
          switch (form) {
            case PostViewForm.card:
              return PostViewCard(
                state.post!,
                displayType: displayType,
                openPostCallback: () {
                  context.pushPage(
                    PostPage(
                      postId: state.post!.id,
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
                  duration: context.animationTheme.durMed1,
                  reverseDuration: context.animationTheme.durShort,
                  firstCurve: context.animationTheme.empasizedCurve,
                  secondCurve: context.animationTheme.empasizedCurve,
                  sizeCurve: context.animationTheme.empasizedCurve,
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

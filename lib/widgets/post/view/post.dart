import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/db/db.dart';
import 'package:muffed/interfaces/lemmy/models/models.dart';
import 'package:muffed/theme/models/extentions.dart';
import 'package:muffed/widgets/post/post.dart';

/// The types of ways the posts can display in
///
/// [list] - Used for when the post is displayed in a list
/// [comments] - Used for when the post is displayed at the top of a comment
/// section
enum PostDisplayType { list, comments }

/// Displays a post
class PostWidget extends StatelessWidget {
  const PostWidget({
    this.bloc,
    this.displayType,
    this.post,
    this.postId,
    super.key,
  }) : assert(
          post != null || postId != null || bloc != null,
          'No post defined in PostWidget constructor',
        );

  final PostBloc? bloc;
  final PostDisplayType? displayType;
  final PostView? post;
  final int? postId;

  @override
  Widget build(BuildContext context) {
    if (bloc != null) {
      return BlocProvider.value(
        value: bloc!,
        child: _PostWidget(
          displayType: displayType,
        ),
      );
    } else {
      return BlocProvider(
        create: (context) => PostBloc(
          lem: context.lemmy,
          globalBloc: context.db,
          post: post,
          postId: postId,
        )..add(
            Created(),
          ),
        child: _PostWidget(displayType: displayType),
      );
    }
  }
}

class _PostWidget extends StatelessWidget {
  const _PostWidget({this.displayType, super.key});

  final PostDisplayType? displayType;

  @override
  Widget build(BuildContext context) {
    final postBloc = context.read<PostBloc>();

    void onDownvotePressed() => postBloc.add(DownvotePressed());
    void onUpvotePressed() => postBloc.add(UpvotePressed());
    void onSavePressed() => postBloc.add(SavePostToggled());
    void openMoreMenuCallback() =>
        _openMoreMenu(context: context, bloc: postBloc);
    void openPostCallback() {}
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      if (state.post != null) {
        return PostViewCard(
          post: state.post!,
          displayType: displayType,
          onDownvotePressed: onDownvotePressed,
          onSavePressed: onSavePressed,
          onUpvotePressed: onUpvotePressed,
          openMoreMenuCallback: openMoreMenuCallback,
          openPostCallback: openPostCallback,
        );
      } else {
        return PostViewCard.loading();
      }
    },);
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
                  // context
                  //   ..pop()
                  //   ..pushPage(
                  //     CommunityPage(
                  //       communityId: state.post!.community.id,
                  //       communityName: state.post!.community.name,
                  //     ),
                  //   );
                },
              ),
              // ListTile(
              //   title: const Text('Go to user'),
              //   leading: const Icon(Icons.person),
              //   onTap: () => context
              //     ..pop()
              //     ..pushPage(
              //       UserPage(userId: state.post!.creator.id),
              //     ),
              // ),
            ],
          );
        },
      ),
    ),
  );
}

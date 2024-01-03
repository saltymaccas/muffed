import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/community/community.dart';
import 'package:muffed/pages/user/user.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/theme/models/extentions.dart';
import 'package:muffed/utils/time.dart';
import 'package:muffed/widgets/markdown_body.dart';
import 'package:muffed/widgets/muffed_avatar.dart';
import 'package:muffed/widgets/post/post.dart';
import 'package:muffed/widgets/url_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Displays a Lemmy post in card format
class PostViewCard extends StatelessWidget {
  const PostViewCard(
    this.post, {
    PostDisplayType? displayType,
    this.openPostCallback,
    this.openMoreMenuCallback,
    super.key,
  })  : displayType = displayType ?? PostDisplayType.list,
        skeletonise = false;

  /// Creates a card post as a skeleton and with placeholder data
  PostViewCard.loading({
    LemmyPost? placeHolderData,
    PostDisplayType? displayType,
    super.key,
  })  : displayType = displayType ?? PostDisplayType.list,
        post = placeHolderData ?? LemmyPost.placeHolder(),
        openPostCallback = null,
        openMoreMenuCallback = null,
        skeletonise = true;

  /// The lemmy post
  final LemmyPost post;

  final PostDisplayType displayType;

  final void Function()? openPostCallback;

  final void Function()? openMoreMenuCallback;

  final bool skeletonise;

  @override
  Widget build(BuildContext context) {
    // shows nothing if nsfw and show nsfw off
    if (post.nsfw && !context.read<GlobalBloc>().state.showNsfw) {
      return const SizedBox();
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      child: Skeletonizer(
        enabled: skeletonise,
        containersColor: context.colorScheme.surface,
        effect: ShimmerEffect(
          baseColor: context.colorScheme.surfaceVariant,
          highlightColor: context.colorScheme.outline,
        ),
        child: InkWell(
          onTap: displayType == PostDisplayType.list ? openPostCallback : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pushPage(
                          CommunityPage(
                            communityId: post.communityId,
                            communityName: post.communityName,
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              MuffedAvatar(
                                url: post.communityIcon,
                                radius: 12,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                post.communityName,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pushPage(
                                    UserPage(
                                      userId: post.creatorId,
                                    ),
                                  );
                                },
                                child: Text(
                                  post.creatorName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${formattedPostedAgo(post.timePublished)} ago',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      post.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  if (post.url != null) ...[
                    UrlView(
                      url: post.url!,
                      nsfw: post.nsfw,
                      imageFullScreenable:
                          displayType == PostDisplayType.comments,
                    ),
                  ],
                  if (post.body != '' && post.body != null) ...[
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 4,
                            left: 4,
                            right: 4,
                            bottom: displayType == PostDisplayType.list ? 0 : 4,
                          ),
                          child: MuffedMarkdownBody(
                            data: post.body!,
                            maxHeight: displayType == PostDisplayType.list
                                ? 300
                                : null,
                            onTapText: () {
                              if (displayType == PostDisplayType.list &&
                                  openPostCallback != null) {
                                openPostCallback!.call();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.mode_comment_outlined),
                        const SizedBox(
                          width: 5,
                        ),
                        Text('${post.commentCount}'),
                      ],
                    ),
                    Row(
                      children: [
                        if (context.read<GlobalBloc>().state.isLoggedIn)
                          IconButton(
                            onPressed: () {
                              context.read<PostBloc>().add(SavePostToggled());
                            },
                            icon: AnimatedCrossFade(
                              crossFadeState: post.saved
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: context.animationTheme.durMed1,
                              reverseDuration: context.animationTheme.durShort,
                              firstCurve: context.animationTheme.empasizedCurve,
                              secondCurve:
                                  context.animationTheme.empasizedCurve,
                              sizeCurve: context.animationTheme.empasizedCurve,
                              firstChild: const Icon(
                                Icons.bookmark,
                                color: Colors.red,
                              ),
                              secondChild: const Icon(Icons.bookmark_outline),
                            ),
                          ),
                        IconButton(
                          icon: const Icon(Icons.arrow_upward_outlined),
                          color: (post.myVote == LemmyVoteType.upVote)
                              ? Colors.deepOrange
                              : null,
                          onPressed: () {
                            context.read<PostBloc>().add(UpvotePressed());
                          },
                          visualDensity: VisualDensity.compact,
                        ),
                        Text(post.upVotes.toString()),
                        IconButton(
                          icon: const Icon(Icons.arrow_downward_outlined),
                          color: (post.myVote == LemmyVoteType.downVote)
                              ? Colors.purple
                              : null,
                          onPressed: () {
                            context.read<PostBloc>().add(DownvotePressed());
                          },
                          visualDensity: VisualDensity.compact,
                        ),
                        Text(post.downVotes.toString()),
                        IconButton(
                          onPressed: openMoreMenuCallback,
                          icon: const Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

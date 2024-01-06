import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/db/db.dart';
import 'package:muffed/interfaces/lemmy/lemmy.dart';
import 'package:muffed/interfaces/lemmy/models/models.dart';
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
  const PostViewCard({
    required this.post,
    PostDisplayType? displayType,
    this.openPostCallback,
    this.openMoreMenuCallback,
    this.onDownvotePressed,
    this.onUpvotePressed,
    this.onSavePressed,
    super.key,
  })  : displayType = displayType ?? PostDisplayType.list,
        skeletonise = false;

  /// Creates a card post as a skeleton and with placeholder data
  PostViewCard.loading({
    PostView? placeHolderData,
    PostDisplayType? displayType,
    super.key,
  })  : displayType = displayType ?? PostDisplayType.list,
        post = placeHolderData ?? postPlaceHolder,
        openPostCallback = null,
        openMoreMenuCallback = null, onDownvotePressed = null, onSavePressed = null, onUpvotePressed = null,
        skeletonise = true;

  /// The lemmy post
  final PostView post;

  final PostDisplayType displayType;

  final void Function()? openPostCallback;

  final void Function()? openMoreMenuCallback;

  final void Function()? onDownvotePressed;

  final void Function()? onUpvotePressed;

  final void Function()? onSavePressed;

  final bool skeletonise;

  @override
  Widget build(BuildContext context) {
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
                        // context.pushPage(
                          // FIXME:
                          // CommunityPage(
                          //   communityId: post.community.id,
                          //   communityName: post.community.name,
                          // ),
                       // );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              MuffedAvatar(
                                url: post.community.icon,
                                identiconID: post.community.name,
                                radius: 12,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                post.community.name,
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
                                  // context.pushPage(
                                  //   UserPage(
                                  //     userId: post.creator.id,
                                  //   ),
                                  // );
                                },
                                child: Text(
                                  post.creator.name,
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
                            '${formattedPostedAgo(post.post.published)} ago',
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
                      post.post.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  if (post.post.url != null) ...[
                    UrlView(
                      url: post.post.url!,
                      nsfw: post.post.nsfw,
                      imageFullScreenable:
                          displayType == PostDisplayType.comments,
                    ),
                  ],
                  if (post.post.body != '' && post.post.body != null) ...[
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
                            data: post.post.body!,
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
                        Text('${post.counts.comments}'),
                      ],
                    ),
                    Row(
                      children: [
                        if (context.db.state.auth.lemmy.loggedIn)
                          IconButton(
                            onPressed:
                              onSavePressed
                            ,
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
                          color: (post.myVote == 1) ? Colors.deepOrange : null,
                          onPressed: onUpvotePressed,
                          visualDensity: VisualDensity.compact,
                        ),
                        Text(post.counts.upvotes.toString()),
                        IconButton(
                          icon: const Icon(Icons.arrow_downward_outlined),
                          color: (post.myVote == -1) ? Colors.purple : null,
                          onPressed: onDownvotePressed,
                          visualDensity: VisualDensity.compact,
                        ),
                        Text(post.counts.downvotes.toString()),
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

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
class PostViewCard extends StatefulWidget {
  const PostViewCard(
    this.post, {
    PostDisplayType? displayType,
    this.openPostCallback,
    this.openMoreMenuCallback,
    super.key,
  })  : displayType = displayType ?? PostDisplayType.list,
        skeletonise = false;

  /// Creates a card post as a skeleton and with placeholder data
  PostViewCard.loading({PostDisplayType? displayType, super.key})
      : displayType = displayType ?? PostDisplayType.list,
        post = LemmyPost.placeHolder(),
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
  State<PostViewCard> createState() => _PostViewCardState();
}

class _PostViewCardState extends State<PostViewCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // shows nothing if nsfw and show nsfw off
    if (widget.post.nsfw && !context.read<GlobalBloc>().state.showNsfw) {
      return const SizedBox();
    }

    return Skeletonizer(
      enabled: widget.skeletonise,
      child: Card(
        child: InkWell(
          onTap: widget.displayType == PostDisplayType.list
              ? widget.openPostCallback
              : null,
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
                            communityId: widget.post.communityId,
                            communityName: widget.post.communityName,
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              MuffedAvatar(
                                url: widget.post.communityIcon,
                                radius: 12,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                widget.post.communityName,
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
                                      userId: widget.post.creatorId,
                                    ),
                                  );
                                },
                                child: Text(
                                  widget.post.creatorName,
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
                            '${formattedPostedAgo(widget.post.timePublished)} ago',
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
                      widget.post.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  if (widget.post.url != null) ...[
                    UrlView(
                      url: widget.post.url!,
                      nsfw: widget.post.nsfw,
                      imageFullScreenable:
                          widget.displayType == PostDisplayType.comments,
                    ),
                  ],
                  if (widget.post.body != '' && widget.post.body != null) ...[
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
                            bottom: widget.displayType == PostDisplayType.list
                                ? 0
                                : 4,
                          ),
                          child: MuffedMarkdownBody(
                            data: widget.post.body!,
                            maxHeight:
                                widget.displayType == PostDisplayType.list
                                    ? 300
                                    : null,
                            onTapText: () {
                              if (widget.displayType == PostDisplayType.list &&
                                  widget.openPostCallback != null) {
                                widget.openPostCallback!.call();
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
                        Text('${widget.post.commentCount}'),
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
                              crossFadeState: widget.post.saved
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration:
                                  context.animationTheme.switchInDurationSmall,
                              reverseDuration:
                                  context.animationTheme.switchOutDurationSmall,
                              firstCurve:
                                  context.animationTheme.switchCurveSmall,
                              secondCurve:
                                  context.animationTheme.switchCurveSmall,
                              sizeCurve:
                                  context.animationTheme.switchCurveSmall,
                              firstChild: const Icon(
                                Icons.bookmark,
                                color: Colors.red,
                              ),
                              secondChild: const Icon(Icons.bookmark_outline),
                            ),
                          ),
                        IconButton(
                          icon: const Icon(Icons.arrow_upward_outlined),
                          color: (widget.post.myVote == LemmyVoteType.upVote)
                              ? Colors.deepOrange
                              : null,
                          onPressed: () {
                            context.read<PostBloc>().add(UpvotePressed());
                          },
                          visualDensity: VisualDensity.compact,
                        ),
                        Text(widget.post.upVotes.toString()),
                        IconButton(
                          icon: const Icon(Icons.arrow_downward_outlined),
                          color: (widget.post.myVote == LemmyVoteType.downVote)
                              ? Colors.purple
                              : null,
                          onPressed: () {
                            context.read<PostBloc>().add(DownvotePressed());
                          },
                          visualDensity: VisualDensity.compact,
                        ),
                        Text(widget.post.downVotes.toString()),
                        IconButton(
                          onPressed: widget.openMoreMenuCallback,
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

  @override
  bool get wantKeepAlive => true;
}

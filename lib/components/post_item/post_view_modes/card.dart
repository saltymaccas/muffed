import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/markdown_body.dart';
import 'package:muffed/components/url_view.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/time.dart';

import '../bloc/bloc.dart';
import '../post_more_menu_button.dart';

/// Displays a Lemmy post in card format
class CardLemmyPostItem extends StatelessWidget {
  ///
  const CardLemmyPostItem(
    this.post, {
    this.limitContentHeight = true,
    this.openOnTap = true,
    super.key,
  });

  /// The lemmy post
  final LemmyPost post;

  /// Whether the post should open when tapped
  final bool openOnTap;

  /// Whether the height of the text should be capped
  final bool limitContentHeight;

  @override
  Widget build(BuildContext context) {
    // shows nothing if nsfw and show nsfw off
    if (post.nsfw && !context.read<GlobalBloc>().state.showNsfw) {
      return const SizedBox();
    }

    void openPost() {
      context.push('/home/content', extra: (post, context));
    }

    return Card(
      child: InkWell(
        onTap: openOnTap ? openPost : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push(
                          '/home/community?community_id=${post.communityId}');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(45),
                                    child: (post.communityIcon != null)
                                        ? CachedNetworkImage(
                                            imageUrl: post.communityIcon!,
                                          )
                                        : Image.asset('assets/logo.png'),
                                  ),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  post.communityName,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.push(
                                        '/home/person?id=${post.creatorId}');
                                  },
                                  child: Text(
                                    post.creatorName,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          formattedPostedAgo(post.timePublished) + ' ago',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
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
            Builder(
              builder: (context) {
                return Column(
                  children: [
                    if (post.url != null) ...[
                      UrlView(
                        url: post.url!,
                        nsfw: post.nsfw,
                      ),
                    ],
                    if (post.body != '' && post.body != null) ...[
                      Builder(
                        builder: (context) {
                          return Padding(
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
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: MuffedMarkdownBody(
                                      data: post.body!,
                                      height: limitContentHeight ? 300 : null,
                                      onTapText: () {
                                        if (openOnTap) {
                                          openPost();
                                        }
                                      },
                                    ),
                                  ),
                                  Builder(
                                    builder: (context) {
                                      return SizedBox();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
                      if (context.read<GlobalBloc>().isLoggedIn())
                        IconButton(
                          onPressed: () {
                            context.read<PostItemBloc>().add(SavePostToggled());
                          },
                          icon: Icon(
                            (post.saved)
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                          ),
                          color: (post.saved) ? Colors.red : null,
                        ),
                      IconButton(
                        icon: const Icon(Icons.arrow_upward_outlined),
                        color: (post.myVote == LemmyVoteType.upVote)
                            ? Colors.deepOrange
                            : null,
                        onPressed: () {
                          context.read<PostItemBloc>().add(UpvotePressed());
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
                          context.read<PostItemBloc>().add(DownvotePressed());
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(post.downVotes.toString()),
                      MoreMenuButton(
                        post: post,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

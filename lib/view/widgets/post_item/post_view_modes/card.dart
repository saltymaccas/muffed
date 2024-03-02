import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:muffed/domain/global_state/bloc.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/utils/time.dart';
import 'package:muffed/view/pages/community/community_screen.dart';
import 'package:muffed/view/pages/post_screen/post_screen.dart';
import 'package:muffed/view/pages/user_screen/user_screen.dart';
import 'package:muffed/view/router/router.dart';
import 'package:muffed/view/widgets/markdown_body.dart';
import 'package:muffed/view/widgets/muffed_avatar.dart';
import 'package:muffed/view/widgets/post_item/bloc/bloc.dart';
import 'package:muffed/view/widgets/post_item/post_item.dart';
import 'package:muffed/view/widgets/post_item/post_more_menu_button.dart';
import 'package:muffed/view/widgets/url_view.dart';

/// Displays a Lemmy post in card format
class CardLemmyPostItem extends StatelessWidget {
  ///
  const CardLemmyPostItem(
    this.post, {
    this.displayType = PostDisplayType.list,
    super.key,
  });

  /// The lemmy post
  final LemmyPost post;

  final PostDisplayType displayType;

  @override
  Widget build(BuildContext context) {
    // shows nothing if nsfw and show nsfw off
    if (post.nsfw && !context.read<GlobalBloc>().state.showNsfw) {
      return const SizedBox();
    }

    void openPost() {
      MNavigator.of(context).pushPage(
        PostPage(
          postBloc: BlocProvider.of<PostItemBloc>(context),
          post: post,
        ),
      );
    }

    return Card(
      child: InkWell(
        onTap: displayType == PostDisplayType.list ? openPost : null,
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
                      MNavigator.of(context).pushPage(
                        CommunityPage(communityId: post.communityId),
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
                                MNavigator.of(context)
                                    .pushPage(UserPage(userId: post.creatorId));
                              },
                              child: Text(
                                post.creatorName,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.outline,
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
            Builder(
              builder: (context) {
                return Column(
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
                              bottom:
                                  displayType == PostDisplayType.list ? 0 : 4,
                            ),
                            child: MuffedMarkdownBody(
                              data: post.body!,
                              maxHeight: displayType == PostDisplayType.list
                                  ? 300
                                  : null,
                              onTapText: () {
                                if (displayType == PostDisplayType.list) {
                                  openPost();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
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

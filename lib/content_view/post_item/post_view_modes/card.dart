import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/image.dart';
import 'package:muffed/components/markdown_body.dart';
import 'package:muffed/content_view/post_item/more_menu_button.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/time.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/bloc.dart';

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
                      context.push('/home/community?id=${post.communityId}');
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
                                        : SvgPicture.asset('assets/logo.svg'),
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
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(post.name, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Builder(
              builder: (context) {
                return Column(
                  children: [
                    if (post.url != null) ...[
                      Builder(
                        builder: (context) {
                          if (post.url!.contains('.jpg') ||
                              post.url!.contains('.png') ||
                              post.url!.contains('.jpeg') ||
                              post.url!.contains('.gif') ||
                              post.url!.contains('.webp') ||
                              post.url!.contains('.bmp')) {
                            return SizedBox(
                              child: Center(
                                child: MuffedImage(
                                  imageUrl: post.url!,
                                  shouldBlur: post.nsfw &&
                                      context.read<GlobalBloc>().state.blurNsfw,
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(4),
                              child: SizedBox(
                                height: 100,
                                child: AnyLinkPreview(
                                  cache: const Duration(days: 1),
                                  placeholderWidget: Container(
                                    height: double.maxFinite,
                                    width: double.maxFinite,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    child: const Center(
                                      child: Text('Loading url data'),
                                    ),
                                  ),
                                  errorImage: 'null',
                                  errorBody: 'Could not load body',
                                  errorTitle: post.name,
                                  errorWidget: GestureDetector(
                                    onTap: () =>
                                        launchUrl(Uri.parse(post.url!)),
                                    child: Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        post.url!,
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                  bodyTextOverflow: TextOverflow.fade,
                                  removeElevation: true,
                                  borderRadius: 10,
                                  boxShadow: const [],
                                  link: post.url!,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  titleStyle:
                                      Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                    if (post.body != '' && post.body != null) ...[
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
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
                        ),
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
                      MoreMenuButton(post: post),
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

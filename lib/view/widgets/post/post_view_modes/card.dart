import 'package:flutter/material.dart';
import 'package:muffed/utils/time.dart';
import 'package:muffed/view/widgets/markdown_body.dart';
import 'package:muffed/view/widgets/muffed_avatar.dart';
import 'package:muffed/view/widgets/url_view.dart';

/// Displays a Lemmy post in card format
class CardLemmyPostItem extends StatelessWidget {
  const CardLemmyPostItem({
    required this.nsfw,
    required this.name,
    required this.communityIcon,
    required this.communityName,
    required this.creatorName,
    required this.timePublished,
    required this.saved,
    required this.vote,
    required this.upvotes,
    required this.downvotes,
    required this.commentCount,
    required this.url,
    required this.body,
    required this.isAuthenticated,
    this.canFullScreenImages = false,
    this.restrictBodyHeight = true,
    this.onTap,
    this.onCommunityTap,
    this.onCreatorTap,
    this.onSaveTap,
    this.onUpvoteTap,
    this.onDownvoteTap,
    super.key,
  });

  final bool nsfw;
  final String name;
  final String communityIcon;
  final String communityName;
  final String creatorName;
  final DateTime timePublished;

  final bool saved;

  final int vote;
  final int upvotes;
  final int downvotes;

  final int commentCount;

  final String? url;
  final String? body;

  final bool canFullScreenImages;
  final bool restrictBodyHeight;
  final bool isAuthenticated;

  final void Function()? onTap;
  final void Function()? onCommunityTap;
  final void Function()? onCreatorTap;
  final void Function()? onSaveTap;
  final void Function()? onUpvoteTap;
  final void Function()? onDownvoteTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final communityNameStyle = theme.textTheme.labelLarge!.copyWith(
      color: theme.colorScheme.primary,
    );

    final creatorNameStyle = theme.textTheme.labelLarge!.copyWith(
      color: theme.colorScheme.outline,
    );

    final timeStampTextStyle = theme.textTheme.labelLarge!.copyWith(
      color: Theme.of(context).colorScheme.outline,
    );

    final postNameTextStyle = Theme.of(context).textTheme.titleMedium;

    final String timeStamp = '${formattedPostedAgo(timePublished)} ago';

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onCommunityTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            MuffedAvatar(
                              url: communityIcon,
                              radius: 12,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              communityName,
                              style: communityNameStyle,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: onCreatorTap,
                              child: Text(creatorName, style: creatorNameStyle),
                            ),
                          ],
                        ),
                        Text(timeStamp, style: timeStampTextStyle),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    name,
                    style: postNameTextStyle,
                  ),
                ],
              ),
            ),
            Builder(
              builder: (context) {
                return Column(
                  children: [
                    if (url != null) ...[
                      UrlView(
                        url: url!,
                        nsfw: nsfw,
                        imageFullScreenable: canFullScreenImages,
                      ),
                    ],
                    if (body != null) ...[
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
                              bottom: restrictBodyHeight ? 0 : 4,
                            ),
                            child: MuffedMarkdownBody(
                              data: body!,
                              maxHeight: restrictBodyHeight ? 300 : null,
                              onTapText: onTap,
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
                      Text(commentCount.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      if (isAuthenticated)
                        IconButton(
                          onPressed: onSaveTap,
                          icon: Icon(
                            saved ? Icons.bookmark : Icons.bookmark_border,
                          ),
                          color: saved ? Colors.red : null,
                        ),
                      IconButton(
                        icon: const Icon(Icons.arrow_upward_outlined),
                        color: (vote == 1) ? Colors.deepOrange : null,
                        onPressed: onUpvoteTap,
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(upvotes.toString()),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward_outlined),
                        color: (vote == -1) ? Colors.purple : null,
                        onPressed: onDownvoteTap,
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(downvotes.toString()),
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

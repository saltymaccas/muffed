import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/utils.dart';
import '../post_more_actions_sheet/post_more_actions_sheet.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class CardLemmyPostItem extends StatelessWidget {
  final LemmyPost post;
  final bool limitContentHeight;
  final void Function(dynamic post)? openContent;

  const CardLemmyPostItem(this.post,
      {this.openContent, this.limitContentHeight = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          if (openContent != null) {
            openContent!(post);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: (post.communityIcon != null)
                              ? Image.network(
                                  post.communityIcon! + '?thumbnail=50')
                              : SvgPicture.asset('assets/logo.svg'),
                        ),
                      ),
                      const VerticalDivider(),
                      Text(
                        post.communityName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const VerticalDivider(),
                      Text(
                        post.creatorName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      const VerticalDivider(),
                      Text(
                        formattedPostedAgo(post.timePublished) + ' ago',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(post.name, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Builder(builder: (context) {
              return Column(
                children: [
                  if (post.url != null) ...[
                    Builder(builder: (context) {
                      if (post.url!.contains('.jpg') ||
                          post.url!.contains('.png') ||
                          post.url!.contains('.jpeg') ||
                          post.url!.contains('.gif') ||
                          post.url!.contains('.webp') ||
                          post.url!.contains('.bmp')) {
                        return SizedBox(
                            height: 300,
                            child: Center(
                              child: Image.network(post.url!,
                                  fit: BoxFit.fitWidth),
                            ));
                      } else {
                        return Padding(
                          padding: EdgeInsets.all(4),
                          child: SizedBox(
                            height: 100,
                            child: AnyLinkPreview(
                              errorWidget: GestureDetector(
                                onTap: () => launchUrl(Uri.parse(post.url!)),
                                child: Container(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  padding: EdgeInsets.all(4),
                                  child: Text(
                                    post.url!,
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                              bodyTextOverflow: TextOverflow.fade,
                              removeElevation: true,
                              borderRadius: 10,
                              boxShadow: [],
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
                    })
                  ],
                  if (post.body != '' && post.body != null) ...[
                    Padding(
                      padding: EdgeInsets.all(4),
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
                          child: (limitContentHeight)
                              ? Text(
                                  post.body!,
                                  maxLines: 10,
                                )
                              : MarkdownBody(
                                  data: post.body!,
                                  shrinkWrap: true,
                                  onTapLink: (text, link, title) {
                                    launchUrl(Uri.parse(link!));
                                  },
                                  selectable: true,
                                ),
                        ),
                      ),
                    ),
                  ]
                ],
              );
            }),
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
                        onPressed: () {},
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(post.upVotes.toString()),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward_outlined),
                        onPressed: () {},
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(post.downVotes.toString()),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          showPostMoreActionsSheet(context, post);
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

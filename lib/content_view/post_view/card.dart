import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/utils.dart';
import 'post_more_actions_sheet.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class CardLemmyPostItem extends StatefulWidget {
  final LemmyPost post;
  final bool limitContentHeight;
  final void Function(dynamic post)? openContent;
  final LemmyVoteType voteType;

  const CardLemmyPostItem(this.post,
      {this.openContent,
      this.limitContentHeight = true,
      this.voteType = LemmyVoteType.none,
      super.key});

  @override
  State<CardLemmyPostItem> createState() => _CardLemmyPostItemState();
}

class _CardLemmyPostItemState extends State<CardLemmyPostItem> {
  LemmyVoteType voteType = LemmyVoteType.none;

  @override
  void initState() {
    voteType = widget.voteType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          if (widget.openContent != null) {
            widget.openContent!(widget.post);
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
                  GestureDetector(
                    onTap: () {
                      context.push(
                          '/home/community?id=${widget.post.communityId}');
                    },
                    child: Row(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(45),
                                child: (widget.post.communityIcon != null)
                                    ? Image.network(widget.post.communityIcon! +
                                        '?thumbnail=50')
                                    : SvgPicture.asset('assets/logo.svg'),
                              ),
                            ),
                            const VerticalDivider(),
                            Text(
                              widget.post.communityName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const VerticalDivider(),
                        Text(
                          widget.post.creatorName,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        const VerticalDivider(),
                        Text(
                          formattedPostedAgo(widget.post.timePublished) +
                              ' ago',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(widget.post.name, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Builder(builder: (context) {
              return Column(
                children: [
                  if (widget.post.url != null) ...[
                    Builder(builder: (context) {
                      if (widget.post.url!.contains('.jpg') ||
                          widget.post.url!.contains('.png') ||
                          widget.post.url!.contains('.jpeg') ||
                          widget.post.url!.contains('.gif') ||
                          widget.post.url!.contains('.webp') ||
                          widget.post.url!.contains('.bmp')) {
                        return SizedBox(
                            height: 300,
                            child: Center(
                              child: Image.network(widget.post.url!,
                                  fit: BoxFit.fitWidth),
                            ));
                      } else {
                        return Padding(
                          padding: EdgeInsets.all(4),
                          child: SizedBox(
                            height: 100,
                            child: AnyLinkPreview(
                              errorImage: 'null',
                              errorBody: 'Could not load body',
                              errorTitle: widget.post.name,
                              errorWidget: GestureDetector(
                                onTap: () =>
                                    launchUrl(Uri.parse(widget.post.url!)),
                                child: Container(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  padding: EdgeInsets.all(4),
                                  child: Text(
                                    widget.post.url!,
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                              bodyTextOverflow: TextOverflow.fade,
                              removeElevation: true,
                              borderRadius: 10,
                              boxShadow: [],
                              link: widget.post.url!,
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
                  if (widget.post.body != '' && widget.post.body != null) ...[
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
                          child: (widget.limitContentHeight)
                              ? Text(
                                  widget.post.body!,
                                  maxLines: 10,
                                )
                              : MarkdownBody(
                                  data: widget.post.body!,
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
                      Text('${widget.post.commentCount}'),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_upward_outlined),
                        color: (voteType == LemmyVoteType.upVote)
                            ? Colors.deepOrange
                            : null,
                        onPressed: () async {
                          try {
                            await context.read<ServerRepo>().lemmyRepo.votePost(
                              widget.post.id,
                              LemmyVoteType.upVote,
                            );
                            setState(() {
                              voteType = LemmyVoteType.upVote;
                            });
                          } catch (err) {}
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(widget.post.upVotes.toString()),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward_outlined),
                        color: (voteType == LemmyVoteType.downVote)
                            ? Colors.purple
                            : null,
                        onPressed: () async {
                          try {
                            await context.read<ServerRepo>().lemmyRepo.votePost(
                                  widget.post.id,
                                  LemmyVoteType.downVote,
                                );
                            setState(() {
                              voteType = LemmyVoteType.downVote;
                            });
                          } catch (err) {}
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(widget.post.downVotes.toString()),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          showPostMoreActionsSheet(context, widget.post);
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

import 'package:flutter/material.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/loading.dart';
import 'package:server_api/lemmy/models.dart';
import 'package:muffed/utils/utils.dart';
import '../post_more_actions_sheet/post_more_actions_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class CardLemmyPostItem extends StatelessWidget {
  final LemmyPost post;

  const CardLemmyPostItem(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
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
                              : Image.asset('assets/Lemmy_logo.png'),
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
            _CardLemmyPostItemContentView(post),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.mode_comment_outlined,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('${post.commentCount}'),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_upward_outlined),
                        onPressed: () {},
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(post.upVotes.toString()),
                      IconButton(
                        icon: Icon(Icons.arrow_downward_outlined),
                        onPressed: () {},
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(post.downVotes.toString()),
                      IconButton(
                        icon: Icon(Icons.more_vert),
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

class _CardLemmyPostItemContentView extends StatelessWidget {
  final LemmyPost post;

  const _CardLemmyPostItemContentView(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    late Widget urlWidget;

    if (post.url != null) {
    } else {
      urlWidget = Container();
    }

    return Column(
      children: [
        if (post.url != null) ...[
          if (post.contentType == ContentType.image) ...[
            Image.network(

              post.url!,
              fit: BoxFit.fill,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ]
        ],
        if (post.body != null) ...[
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
                child: Text(
                  post.body!,
                  maxLines: 8,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          )
        ]
      ],
    );
  }
}

class UrlDisplay extends StatefulWidget {
  const UrlDisplay(this.url, {super.key});

  final String url;

  @override
  State<UrlDisplay> createState() => _UrlDisplayState();
}

class _UrlDisplayState extends State<UrlDisplay>
    with AutomaticKeepAliveClientMixin {
  String? type;

  @override
  Widget build(BuildContext context) {
    if (type == null) {
      return FutureBuilder(
        future: http.head(Uri.parse(widget.url)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            CachedNetworkImage(
              imageUrl: widget.url,
              progressIndicatorBuilder:
                  (context, String string, DownloadProgress progress) {
                return Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                  ),
                );
              },
            );
            return const ErrorComponentTransparent(message: 'Future Error');
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.headers['content-type'] != null) {
              if (RegExp('image/*.')
                  .hasMatch(snapshot.data!.headers['content-type']!)) {
                type = 'image';
                return CachedNetworkImage(
                  imageUrl: widget.url,
                  progressIndicatorBuilder:
                      (context, String string, DownloadProgress progress) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                      ),
                    );
                  },
                );
              }
            }
          }
          return Container();
        },
      );
    } else {
      if (type == 'image') {
        return CachedNetworkImage(
          imageUrl: widget.url,
          progressIndicatorBuilder:
              (context, String string, DownloadProgress progress) {
            return Center(
              child: CircularProgressIndicator(
                value: progress.progress,
              ),
            );
          },
        );
      } else {
        return Text(widget.url);
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}

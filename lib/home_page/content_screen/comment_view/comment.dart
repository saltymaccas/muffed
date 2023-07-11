import 'package:flutter/material.dart';
import 'package:muffed/repo/lemmy/models.dart';

class CommentItem extends StatefulWidget {
  const CommentItem(this.comment, {super.key});

  final LemmyComment comment;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {

  bool isMinimised = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        setState(() {
          isMinimised = !isMinimised;
        });
      },
      child: IntrinsicHeight(
        child:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.comment.level != 0) ...[
              Container(
                width: 1,
                color: Theme.of(context).colorScheme.outline,
              ),
            ],
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: (!isMinimised) ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.comment.creatorName,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      )
                    ],
                  ),
                  Text(widget.comment.content),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_upward_rounded),
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(widget.comment.upVotes.toString()),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_downward_rounded),
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(widget.comment.downVotes.toString()),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.reply),
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.more_vert)),
                    ],
                  ),
                  for (final LemmyComment reply in widget.comment.replies)
                    CommentItem(reply)
                ],
              ) : Text(widget.comment.content, maxLines: 1,)
            ),
          ],
        ),
      ),
    );
  }
}

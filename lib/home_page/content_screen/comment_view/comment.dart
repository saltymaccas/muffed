import 'package:flutter/material.dart';
import 'package:muffed/repo/lemmy/models.dart';

class CommentItem extends StatelessWidget {
  const CommentItem(this.comment, {super.key});

  final LemmyComment comment;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (comment.level != 0) ...[
            Container(
              width: 1,
              color: Theme.of(context).colorScheme.outline,
            ),
          ],
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.creatorName,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    )
                  ],
                ),
                Text(comment.content),
                for (final LemmyComment reply in comment.replies)
                  CommentItem(reply)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

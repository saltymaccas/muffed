import 'package:flutter/material.dart';

class CommentFooter extends StatelessWidget {
  const CommentFooter({
    required this.upvotes,
    required this.downvotes,
    this.onUpvoteTap,
    this.onDownvoteTap,
    super.key,
  });

  final int upvotes;
  final int downvotes;

  final void Function()? onUpvoteTap;
  final void Function()? onDownvoteTap;

  double get height => 100;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final votesTextStyle = theme.textTheme.bodyMedium;

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_upward),
          visualDensity: VisualDensity.compact,
          onPressed: onUpvoteTap,
        ),
        Text(
          upvotes.toString(),
          style: votesTextStyle,
        ),
        IconButton(
          icon: const Icon(Icons.arrow_downward),
          visualDensity: VisualDensity.compact,
          onPressed: onDownvoteTap,
        ),
        Text(
          downvotes.toString(),
          style: votesTextStyle,
        ),
      ],
    );
  }
}

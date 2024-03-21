import 'package:flutter/material.dart';
import 'package:muffed/view/widgets/markdown_body.dart';

class CommentBody extends StatelessWidget {
  const CommentBody({required this.commentBody, super.key});

  final String commentBody;

  @override
  Widget build(BuildContext context) {
    return MuffedMarkdownBody(
      data: commentBody,
    );
  }
}

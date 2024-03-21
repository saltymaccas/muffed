import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/view/widgets/comment/bloc/bloc.dart';
import 'package:muffed/view/widgets/comment/models/models.dart';
import 'package:muffed/view/widgets/comment/widgets/body.dart';
import 'package:muffed/view/widgets/comment/widgets/footer.dart';
import 'package:muffed/view/widgets/comment/widgets/header.dart';

class CommentTreeWidget extends StatefulWidget {
  const CommentTreeWidget({
    required this.commentTree,
    this.sortType = CommentSortType.hot,
    super.key,
  });

  final CommentTree commentTree;
  final CommentSortType sortType;

  @override
  State<CommentTreeWidget> createState() => _CommentTreeWidgetState();
}

class _CommentTreeWidgetState extends State<CommentTreeWidget> {
  late final CommentBloc commentBloc;

  @override
  void initState() {
    super.initState();
    commentBloc = CommentBloc(commentTree: widget.commentTree);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      bloc: commentBloc,
      builder: (context, state) {
        final comment = state.commentTree.comment;
        return _CommentTreeWidgetScaffold(
          header: CommentHeader(
            creatorName: comment.creator.name,
            creationTime: comment.comment.published,
            creatorIcon: comment.creator.avatar,
          ),
          body: CommentBody(
            commentBody: comment.comment.content,
          ),
          footer: CommentFooter(
            upvotes: comment.counts.upvotes,
            downvotes: comment.counts.downvotes,
          ),
        );
      },
    );
  }
}

class _CommentTreeWidgetScaffold extends StatelessWidget {
  const _CommentTreeWidgetScaffold({
    required this.body,
    this.header,
    this.footer,
    super.key,
  });

  final Widget body;
  final Widget? footer;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Column(
        children: [
          if (header != null) header!,
          body,
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

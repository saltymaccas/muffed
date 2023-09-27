import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/comment_item/bloc/bloc.dart';
import 'package:muffed/components/markdown_body.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/comments.dart';
import 'package:muffed/utils/time.dart';

/// Used to display a single comment in a listview, this widget will also show
/// all the children comments,

class CommentItem extends StatelessWidget {
  const CommentItem({
    required this.comment,
    required this.children,
    super.key,
  });

  final LemmyComment comment;
  final List<LemmyComment> children;

  @override
  Widget build(BuildContext context) {
    final organisedComments =
        organiseCommentsWithChildren(comment.getLevel() + 1, children);

    final List<Widget> childrenWidgets =
        List.generate(organisedComments.length, (index) {
      final key = organisedComments.keys.toList()[index];
      return CommentItem(comment: key, children: organisedComments[key]!);
    });

    return BlocProvider(
      create: (context) => CommentItemBloc(comment: comment),
      child: BlocBuilder<CommentItemBloc, CommentItemState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                left: (comment.path.isNotEmpty)
                    ? BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      )
                    : BorderSide.none,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        comment.creatorName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        formattedPostedAgo(
                          comment.timePublished,
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  MuffedMarkdownBody(data: comment.content),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_upward_rounded,
                          color: (comment.myVote == LemmyVoteType.upVote)
                              ? Colors.deepOrange
                              : null,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(comment.upVotes.toString()),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_downward_rounded,
                          color: (comment.myVote == LemmyVoteType.downVote)
                              ? Colors.purple
                              : null,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(comment.downVotes.toString()),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.reply),
                        visualDensity: VisualDensity.compact,
                      ),
                      MuffedPopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        items: [
                          MuffedPopupMenuItem(
                            title: 'Show Debug Info',
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'id: ${comment.id}',
                                        ),
                                        Text(
                                          'childCount: ${comment.childCount}',
                                        ),
                                        Text(
                                          'content: ${comment.content}',
                                        ),
                                        Text('path: ${comment.path}'),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          MuffedPopupMenuItem(
                            title: 'Go to user',
                            onTap: () {
                              context.push(
                                '/home/person?id=${comment.creatorId}',
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  ...childrenWidgets,
                  // ...generateChildren(),
                  // // this my prevent comments from showing
                  // if (comment.childCount > comment.getNumberOfReplies() &&
                  //     comment.replies.isEmpty &&
                  //     widget.onLoadMorePressed != null)
                  //   InkWell(
                  //     onTap: () {
                  //       widget.onLoadMorePressed!(comment.id);
                  //     },
                  //     child: Container(
                  //       child: Text(
                  //           'Load ${comment.childCount - comment.getNumberOfReplies()} more'),
                  //     ),
                  //   )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

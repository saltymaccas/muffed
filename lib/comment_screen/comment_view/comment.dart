import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/markdown_body.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/utils/time.dart';

import '../../repo/server_repo.dart';

/// Used to display a single comment in a listview, this widget will also show
/// all the children comments,
class CommentItem extends StatefulWidget {
  const CommentItem({
    required this.comment,
    required this.onReplyPressed,
    this.onLoadMorePressed,
    super.key,
  });

  final LemmyComment comment;

  /// The function to run when the reply button is pressed
  final void Function(int parentId, String parantContent) onReplyPressed;

  final void Function(int id)? onLoadMorePressed;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isMinimised = false;
  late LemmyComment comment;
  int replyPagesLoaded = 0;

  @override
  void initState() {
    comment = widget.comment;
    super.initState();
  }

  Future<void> upvotePressed() async {
    // saves what the last vote is in order to reverse
    // the vote in the state if an error occurs
    final lastVote = comment.myVote;

    if (comment.myVote == LemmyVoteType.upVote) {
      setState(() {
        comment
          ..upVotes = comment.upVotes - 1
          ..myVote = LemmyVoteType.none;
      });
      try {
        // tries to change the vote
        await context.read<ServerRepo>().lemmyRepo.voteComment(
              comment.id,
              LemmyVoteType.none,
            );
      } catch (err) {
        // reverts the vote state if an error occurs
        setState(() {
          comment
            ..upVotes = comment.upVotes + 1
            ..myVote = lastVote;
        });
      }
    } else {
      // If last vote was downVote a downVote should
      // be taken off.
      if (comment.myVote == LemmyVoteType.downVote) {
        setState(() {
          comment.downVotes = comment.downVotes - 1;
        });
      }
      setState(() {
        comment
          ..upVotes = comment.upVotes + 1
          ..myVote = LemmyVoteType.upVote;
      });
      try {
        // tries to change the vote
        await context.read<ServerRepo>().lemmyRepo.voteComment(
              comment.id,
              LemmyVoteType.upVote,
            );
      } catch (err) {
        // reverts the vote state if an error occurs
        setState(() {
          comment
            ..upVotes = comment.upVotes - 1
            ..myVote = lastVote;
        });
      }
    }
  }

  Future<void> downvotePressed() async {
    // saves what the last vote is in order to reverse
    // the vote in the state if an error occurs
    final lastVote = comment.myVote;

    if (comment.myVote == LemmyVoteType.downVote) {
      setState(() {
        comment
          ..downVotes = comment.downVotes - 1
          ..myVote = LemmyVoteType.none;
      });
      try {
        // tries to change the vote
        await context.read<ServerRepo>().lemmyRepo.voteComment(
              comment.id,
              LemmyVoteType.none,
            );
      } catch (err) {
        // reverts the vote state if an error occurs
        setState(() {
          comment
            ..downVotes = comment.downVotes + 1
            ..myVote = lastVote;
        });
      }
    } else {
      // If last vote was upVote a upVote should
      // be taken off.
      if (comment.myVote == LemmyVoteType.upVote) {
        setState(() {
          comment.upVotes = comment.upVotes - 1;
        });
      }
      setState(() {
        comment
          ..downVotes = comment.downVotes + 1
          ..myVote = LemmyVoteType.downVote;
      });
      try {
        // tries to change the vote
        await context.read<ServerRepo>().lemmyRepo.voteComment(
              comment.id,
              LemmyVoteType.downVote,
            );
      } catch (err) {
        // reverts the vote state if an error occurs
        setState(() {
          comment
            ..downVotes = comment.downVotes - 1
            ..myVote = lastVote;
        });
      }
    }
  }

  List<Widget> generateChildren() {
    List<Widget> children = [];

    for (final reply in comment.replies) {
      children.add(
        CommentItem(
          comment: reply,
          onReplyPressed: (_, __) {
            widget.onReplyPressed(
              reply.id,
              reply.content,
            );
          },
        ),
      );
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: Alignment.topCenter,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          if (isMinimised) {
            setState(() {
              isMinimised = false;
            });
          }
        },
        onLongPress: () {
          setState(() {
            isMinimised = !isMinimised;
          });
        },
        child: (!isMinimised)
            ? Container(
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
                            onPressed: upvotePressed,
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
                            onPressed: downvotePressed,
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
                            onPressed: () {
                              widget.onReplyPressed(
                                comment.id,
                                comment.content,
                              );
                            },
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
                                            Text('path: ${comment.path}')
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
                      ...generateChildren(),
                      // this my prevent comments from showing
                      if (comment.childCount > comment.getNumberOfReplies() &&
                          comment.replies.isEmpty &&
                          widget.onLoadMorePressed != null)
                        InkWell(
                          onTap: () {
                            widget.onLoadMorePressed!(comment.id);
                          },
                          child: Container(
                            child: Text(
                                'Load ${comment.childCount - comment.getNumberOfReplies()} more'),
                          ),
                        )
                    ],
                  ),
                ),
              )
            : Text(
                comment.content,
                maxLines: 1,
              ),
      ),
    );
  }
}

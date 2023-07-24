import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/lemmy/models.dart';
import 'package:muffed/utils/time.dart';

import '../../repo/server_repo.dart';

class CommentItem extends StatefulWidget {
  const CommentItem(this.comment, {super.key});

  final LemmyComment comment;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isMinimised = false;
  late LemmyComment comment;

  @override
  void initState() {
    comment = widget.comment;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isMinimised = !isMinimised;
        });
      },
      onLongPress: () {
        setState(() {
          isMinimised = !isMinimised;
        });
      },
      child: IntrinsicHeight(
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
                child: (!isMinimised)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                comment.creatorName,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                formattedPostedAgo(
                                  comment.timePublished,
                                ),
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.outline),
                              ),
                            ],
                          ),
                          Text(comment.content),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () async {
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
                                      await context
                                          .read<ServerRepo>()
                                          .lemmyRepo
                                          .voteComment(
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
                                    if (comment.myVote ==
                                        LemmyVoteType.downVote) {
                                      setState(() {
                                        comment.downVotes =
                                            comment.downVotes - 1;
                                      });
                                    }
                                    setState(() {
                                      comment
                                        ..upVotes = comment.upVotes + 1
                                        ..myVote = LemmyVoteType.upVote;
                                    });
                                    try {
                                      // tries to change the vote
                                      await context
                                          .read<ServerRepo>()
                                          .lemmyRepo
                                          .voteComment(
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
                                },
                                icon: Icon(
                                  Icons.arrow_upward_rounded,
                                  color:
                                      (comment.myVote == LemmyVoteType.upVote)
                                          ? Colors.deepOrange
                                          : null,
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              Text(comment.upVotes.toString()),
                              IconButton(
                                onPressed: () async {
                                  // saves what the last vote is in order to reverse
                                  // the vote in the state if an error occurs
                                  final lastVote = comment.myVote;

                                  if (comment.myVote ==
                                      LemmyVoteType.downVote) {
                                    setState(() {
                                      comment
                                        ..downVotes = comment.downVotes - 1
                                        ..myVote = LemmyVoteType.none;
                                    });
                                    try {
                                      // tries to change the vote
                                      await context
                                          .read<ServerRepo>()
                                          .lemmyRepo
                                          .voteComment(
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
                                    if (comment.myVote ==
                                        LemmyVoteType.upVote) {
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
                                      await context
                                          .read<ServerRepo>()
                                          .lemmyRepo
                                          .voteComment(
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
                                },
                                icon: Icon(
                                  Icons.arrow_downward_rounded,
                                  color:
                                      (comment.myVote == LemmyVoteType.downVote)
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
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.more_vert)),
                            ],
                          ),
                          for (final LemmyComment reply in comment.replies)
                            CommentItem(reply)
                        ],
                      )
                    : Text(
                        comment.content,
                        maxLines: 1,
                      )),
          ],
        ),
      ),
    );
  }
}

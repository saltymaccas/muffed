import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/comment_item/bloc/bloc.dart';
import 'package:muffed/components/markdown_body.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/components/snackbars.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/comments.dart';
import 'package:muffed/utils/time.dart';

/// Used to display a single comment in a listview, this widget will also show
/// all the children comments,

class CommentItem extends StatefulWidget {
  const CommentItem({
    required this.comment,
    required this.children,
    required this.sortType,
    this.isOrphan = true,
    this.postCreatorId,
    super.key,
  });

  final LemmyComment comment;
  final List<LemmyComment> children;
  final LemmyCommentSortType sortType;

  /// The id of the creator of the post the comment is on, used to mark the
  /// comment if it is by the same person who made the post
  final int? postCreatorId;

  /// Whether the comment has a parent comment
  final bool isOrphan;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => CommentItemBloc(
        comment: widget.comment,
        children: widget.children,
        repo: context.read<ServerRepo>(),
        globalBloc: context.read<GlobalBloc>(),
      ),
      child: BlocConsumer<CommentItemBloc, CommentItemState>(
        listener: (context, state) {
          if (state.error != null) {
            showErrorSnackBar(context, error: state.error);
          }
        },
        builder: (context, state) {
          final organisedComments = organiseCommentsWithChildren(
            widget.comment.getLevel() + 1,
            state.children,
          );

          final List<Widget> childrenWidgets =
              List.generate(organisedComments.length, (index) {
            final key = organisedComments.keys.toList()[index];
            return CommentItem(
              key: ValueKey<int>(key.id),
              comment: key,
              children: organisedComments[key]!,
              sortType: widget.sortType,
              isOrphan: false,
              postCreatorId: widget.postCreatorId,
            );
          });

          // TODO: create nicer looking minimised comment
          return InkWell(
            onLongPress: () {
              context.read<CommentItemBloc>().add(MinimiseToggled());
            },
            onTap: () {
              if (state.minimised) {
                context.read<CommentItemBloc>().add(MinimiseToggled());
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: (widget.comment.path.isNotEmpty)
                      ? BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        )
                      : BorderSide.none,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: AnimatedSize(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                  alignment: Alignment.topCenter,
                  child: state.minimised
                      ? Text(
                          widget.comment.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.comment.creatorName,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  formattedPostedAgo(
                                    widget.comment.timePublished,
                                  ),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                if (widget.postCreatorId == state.comment.id)
                                  Icon(
                                    Icons.mic_external_on_sharp,
                                    size: 12,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                              ],
                            ),
                            MuffedMarkdownBody(data: widget.comment.content),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<CommentItemBloc>()
                                        .add(UpvotePressed());
                                  },
                                  icon: Icon(
                                    Icons.arrow_upward_rounded,
                                    color: (state.comment.myVote ==
                                            LemmyVoteType.upVote)
                                        ? Colors.deepOrange
                                        : null,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                                Text(state.comment.upVotes.toString()),
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<CommentItemBloc>()
                                        .add(DownvotePressed());
                                  },
                                  icon: Icon(
                                    Icons.arrow_downward_rounded,
                                    color: (state.comment.myVote ==
                                            LemmyVoteType.downVote)
                                        ? Colors.purple
                                        : null,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                                Text(state.comment.downVotes.toString()),
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
                                      title: 'Go to user',
                                      onTap: () {
                                        context.push(
                                          '/home/person?id=${widget.comment.creatorId}',
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ...childrenWidgets,
                            if (state.comment.childCount > 0 &&
                                state.children.isEmpty)
                              InkWell(
                                onTap: () {
                                  context.read<CommentItemBloc>().add(
                                        LoadChildrenRequested(widget.sortType),
                                      );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: (widget.comment.path.isNotEmpty)
                                          ? BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              width: 1,
                                            )
                                          : BorderSide.none,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      state.loadingChildren
                                          ? 'Loading...'
                                          : 'Load ${state.comment.childCount} more',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            if (widget.isOrphan) Divider(),
                          ],
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/comment_item/bloc/bloc.dart';
import 'package:muffed/components/create_comment/create_comment_dialog.dart';
import 'package:muffed/components/markdown_body.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/components/snackbars.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/comments.dart';
import 'package:muffed/utils/time.dart';

/// Used to display a single comment in a listview, this widget will also show
/// all the children comments if needed.
class CommentItem extends StatefulWidget {
  /// Used to display a single comment in a listview
  const CommentItem({
    required this.comment,
    required this.sortType,
    this.ableToLoadChildren = true,
    this.children = const [],
    this.isOrphan = true,
    this.postCreatorId,
    this.displayAsSingle = false,
    super.key,
  });

  /// The comment itself
  final LemmyComment comment;

  /// Any children of the comment
  final List<LemmyComment> children;

  /// The sort type of the listview the comment is in
  final LemmyCommentSortType sortType;

  /// If true the comment will display a button to load the comments children
  final bool ableToLoadChildren;

  /// The id of the creator of the post the comment is on, used to mark the
  /// comment if it is by the same person who made the post
  final int? postCreatorId;

  /// Whether the comment does not have a parent
  final bool isOrphan;

  final bool displayAsSingle;

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
                  left: (widget.comment.path.isNotEmpty &&
                          !widget.displayAsSingle)
                      ? BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        )
                      : BorderSide.none,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: AnimatedSize(
                  // TODO: make animation a constant speed (ajusts time based on the height of the comment)
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                  alignment: Alignment.topCenter,
                  child: Builder(
                    builder: (context) {
                      if (state.minimised) {
                        return Text(
                          widget.comment.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }

                      final baseCommentItem = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.comment.creatorName,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
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
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Signal if the comment is from op
                              if (widget.postCreatorId ==
                                  state.comment.creatorId)
                                Text(
                                  'OP',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
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
                                onPressed: () {
                                  showCreateCommentDialog(
                                    context: context,
                                    postId: state.comment.postId,
                                    parentId: state.comment.id,
                                  );
                                },
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
                                  padding: const EdgeInsets.all(8),
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
                          if (widget.isOrphan && !widget.displayAsSingle)
                            const Divider(),
                        ],
                      );

                      if (widget.displayAsSingle) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8, top: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.comment.postTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'In',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                              ),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          widget.comment.communityName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(thickness: 0.5),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: baseCommentItem,
                              ),
                            ],
                          ),
                        );
                      }

                      return baseCommentItem;
                    },
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

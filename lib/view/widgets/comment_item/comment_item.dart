import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muffed/domain/global_state/bloc.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/utils/comments.dart';
import 'package:muffed/utils/time.dart';
import 'package:muffed/view/pages/community_screen/community_screen.dart';
import 'package:muffed/view/pages/post_screen/post_screen.dart';
import 'package:muffed/view/widgets/comment_item/bloc/bloc.dart';
import 'package:muffed/view/widgets/create_comment/create_comment_dialog.dart';
import 'package:muffed/view/widgets/markdown_body.dart';
import 'package:muffed/view/widgets/popup_menu/popup_menu.dart';
import 'package:muffed/view/widgets/snackbars.dart';

enum CommentItemDisplayMode { single, tree }

/// Used to display a single comment in a listview, this widget will also show
/// all the children comments if needed.
class CommentItem extends StatefulWidget {
  /// Used to display a single comment in a listview
  const CommentItem({
    required this.comment,
    this.sortType,
    this.ableToLoadChildren = true,
    this.children = const [],
    this.isOrphan = true,
    this.displayMode = CommentItemDisplayMode.tree,
    this.markedAsReadCallback,
    this.read = false,
    super.key,
  });

  /// The comment itself
  final LemmyComment comment;

  /// Any children of the comment
  final List<LemmyComment> children;

  /// The sort type of the listview the comment is in used for the comment to
  /// get children comments in the same sort type.
  final LemmyCommentSortType? sortType;

  /// If true the comment will display a button to load the comments children
  final bool ableToLoadChildren;

  /// Whether the comment does not have a parent
  final bool isOrphan;

  /// Whether the comment should be displayed as a single comment
  final CommentItemDisplayMode displayMode;

  /// Only used for replies and mentions screen, used to mark the comment as
  /// read
  final void Function()? markedAsReadCallback;

  /// only shows id [markedAsReadCallback] is not null
  final bool read;

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
              } else if (widget.displayMode == CommentItemDisplayMode.single) {
                PostScreenRoute(postId: widget.comment.postId).push(context);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: (widget.comment.path.isNotEmpty &&
                          widget.displayMode == CommentItemDisplayMode.tree)
                      ? BorderSide(
                          color: Theme.of(context).colorScheme.outline,
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
                        if (widget.displayMode ==
                            CommentItemDisplayMode.single) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                widget.comment.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }
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
                              GestureDetector(
                                onTap: () {
                                  context.push(
                                    '/home/person?id=${widget.comment.creatorId}',
                                  );
                                },
                                child: Text(
                                  widget.comment.creatorName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                formattedPostedAgo(
                                  widget.comment.timePublished,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                              ),
                              const SizedBox(width: 10),
                              // Signal if the comment is from op
                              if (widget.comment.postCreatorId ==
                                  state.comment.creatorId) ...[
                                Text(
                                  'OP',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: Colors.blue,
                                      ),
                                ),
                                const SizedBox(width: 4),
                              ],

                              // displays if the user created the comment
                              if (context
                                      .read<GlobalBloc>()
                                      .getSelectedLemmyAccount() !=
                                  null)
                                if (widget.comment.creatorId ==
                                    context
                                        .read<GlobalBloc>()
                                        .getSelectedLemmyAccount()!
                                        .id)
                                  Text(
                                    'YOU',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          color: Colors.green,
                                        ),
                                  ),
                            ],
                          ),
                          MuffedMarkdownBody(data: widget.comment.content),
                          Row(
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
                                icon: const Icon(Icons.more_vert),
                                items: [
                                  MuffedPopupMenuItem(
                                    title: 'Go to user',
                                    onTap: () {
                                      context.push(
                                        '/home/person?id=${widget.comment.creatorId}',
                                      );
                                    },
                                  ),
                                  MuffedPopupMenuItem(
                                    title: 'View raw',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (context) => Scaffold(
                                            appBar: AppBar(),
                                            body: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: SingleChildScrollView(
                                                  child: SelectableText(
                                                    widget.comment.content,
                                                    style:
                                                        GoogleFonts.robotoMono(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  if (context.read<GlobalBloc>().isLoggedIn())
                                    if (widget.comment.creatorId ==
                                        context
                                            .read<GlobalBloc>()
                                            .getSelectedLemmyAccount()!
                                            .id)
                                      MuffedPopupMenuItem(
                                        title: 'Edit Comment',
                                        onTap: () {
                                          showCreateCommentDialog(
                                            context: context,
                                            postId: widget.comment.postId,
                                            commentBeingEdited: widget.comment,
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
                                      LoadChildrenRequested(
                                        widget.sortType ??
                                            LemmyCommentSortType.hot,
                                      ),
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
                                        .labelLarge!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          if (widget.isOrphan &&
                              widget.displayMode == CommentItemDisplayMode.tree)
                            const Divider(),
                        ],
                      );

                      if (widget.displayMode == CommentItemDisplayMode.single) {
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                    .labelLarge!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline,
                                                    ),
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  CommunityScreenRouter(
                                                    communityId: widget
                                                        .comment.communityId,
                                                  ).push(context);
                                                },
                                                child: Text(
                                                  widget.comment.communityName,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (widget.markedAsReadCallback != null)
                                      IconButton(
                                        isSelected: widget.read,
                                        onPressed: widget.markedAsReadCallback,
                                        selectedIcon:
                                            const Icon(Icons.check_circle),
                                        icon: const Icon(
                                          Icons.check_circle_outline,
                                        ),
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

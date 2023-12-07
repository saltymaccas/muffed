import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/time.dart';
import 'package:muffed/widgets/comment/comment.dart';
import 'package:muffed/widgets/create_comment/create_comment_dialog.dart';
import 'package:muffed/widgets/markdown_body.dart';
import 'package:muffed/widgets/popup_menu/popup_menu.dart';
import 'package:muffed/widgets/snackbars.dart';

enum CommentItemDisplayMode { single, tree }

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    required this.comment,
    required this.sortType,
    this.children = const [],
    this.ableToLoadChildren = true,
    this.isOrphan = true,
    this.displayMode = CommentItemDisplayMode.tree,
    this.markedAsReadCallback,
    this.read = false,
    super.key,
  });

  final LemmyComment comment;
  final List<LemmyComment> children;
  final LemmyCommentSortType sortType;
  final bool ableToLoadChildren;
  final bool isOrphan;
  final CommentItemDisplayMode displayMode;
  final void Function()? markedAsReadCallback;
  final bool read;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentItemBloc(
        comment: comment,
        children: children,
        sortType: sortType,
        repo: context.read<ServerRepo>(),
        globalBloc: context.read<GlobalBloc>(),
      ),
      child: CommentView(
        sortType: sortType,
        ableToLoadChildren: ableToLoadChildren,
        isOrphan: isOrphan,
        displayMode: displayMode,
        markedAsReadCallback: markedAsReadCallback,
        read: read,
      ),
    );
  }
}

/// Used to display a single comment in a listview, this widget will also show
/// all the children comments if needed.
class CommentView extends StatefulWidget {
  /// Used to display a single comment in a listview
  const CommentView({
    this.sortType,
    this.ableToLoadChildren = true,
    this.isOrphan = true,
    this.displayMode = CommentItemDisplayMode.tree,
    this.markedAsReadCallback,
    this.read = false,
    super.key,
  });

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

  /// only shows if [markedAsReadCallback] is not null
  final bool read;

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<CommentItemBloc, CommentItemState>(
      listener: (context, state) {
        if (state.error != null) {
          showErrorSnackBar(context, error: state.error);
        }
      },
      builder: (context, state) {
        final organisedComments = organiseCommentsWithChildren(
          state.comment.level + 1,
          state.children,
        );

        final List<Widget> childrenWidgets =
            List.generate(organisedComments.length, (index) {
          final key = organisedComments.keys.toList()[index];
          return CommentWidget(
            sortType: state.sortType,
            key: ValueKey<int>(key.id),
            comment: key,
            children: organisedComments[key]!,
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
            } else if (widget.displayMode == CommentItemDisplayMode.single) {}
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: (state.comment.path.isNotEmpty &&
                        widget.displayMode == CommentItemDisplayMode.tree)
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
                      if (widget.displayMode == CommentItemDisplayMode.single) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              state.comment.content,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }
                      return Text(
                        state.comment.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    }

                    final baseCommentItem = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _CommentItemTopBar(),
                        MuffedMarkdownBody(data: state.comment.content),
                        const _CommentBottomActionBar(),
                        ...childrenWidgets,
                        if (state.comment.childCount > 0 &&
                            state.children.isEmpty)
                          const _CommentLoadChildrenButton(),
                        if (widget.isOrphan &&
                            widget.displayMode == CommentItemDisplayMode.tree)
                          const Divider(),
                      ],
                    );

                    if (widget.displayMode == CommentItemDisplayMode.single) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outlineVariant,
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
                                          state.comment.postTitle,
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
                                                // TODO: add navigation
                                              },
                                              child: Text(
                                                state.comment.communityName,
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
    );
  }
}

/// The button that is displayed when a comment has children that have not
/// yet been loaded, pressing the button loads the children.
class _CommentLoadChildrenButton extends StatelessWidget {
  const _CommentLoadChildrenButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentItemBloc, CommentItemState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<CommentItemBloc>().add(
                  LoadChildrenRequested(),
                );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: (state.comment.path.isNotEmpty)
                    ? BorderSide(
                        color: Theme.of(context).colorScheme.outline,
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
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CommentBottomActionBar extends StatelessWidget {
  const _CommentBottomActionBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentItemBloc, CommentItemState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                context.read<CommentItemBloc>().add(UpvotePressed());
              },
              icon: Icon(
                Icons.arrow_upward_rounded,
                color: (state.comment.myVote == LemmyVoteType.upVote)
                    ? Colors.deepOrange
                    : null,
              ),
              visualDensity: VisualDensity.compact,
            ),
            Text(state.comment.upVotes.toString()),
            IconButton(
              onPressed: () {
                context.read<CommentItemBloc>().add(DownvotePressed());
              },
              icon: Icon(
                Icons.arrow_downward_rounded,
                color: (state.comment.myVote == LemmyVoteType.downVote)
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
                    // TODO: add navigation
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
                              padding: const EdgeInsets.all(8),
                              child: SingleChildScrollView(
                                child: SelectableText(
                                  state.comment.content,
                                  style: GoogleFonts.robotoMono(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyMedium,
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
                  if (state.comment.creatorId ==
                      context.read<GlobalBloc>().getSelectedLemmyAccount()!.id)
                    MuffedPopupMenuItem(
                      title: 'Edit Comment',
                      onTap: () {
                        showCreateCommentDialog(
                          context: context,
                          postId: state.comment.postId,
                          commentBeingEdited: state.comment,
                        );
                      },
                    ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _CommentItemTopBar extends StatelessWidget {
  const _CommentItemTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentItemBloc, CommentItemState>(
      builder: (context, state) {
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                // TODO: add navigation
              },
              child: Text(
                state.comment.creatorName,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              formattedPostedAgo(
                state.comment.timePublished,
              ),
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(width: 10),
            // Signal if the comment is from op
            if (state.comment.postCreatorId == state.comment.creatorId) ...[
              Text(
                'OP',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Colors.blue,
                    ),
              ),
              const SizedBox(width: 4),
            ],

            // displays if the user created the comment
            if (context.read<GlobalBloc>().getSelectedLemmyAccount() != null)
              if (state.comment.creatorId ==
                  context.read<GlobalBloc>().getSelectedLemmyAccount()!.id)
                Text(
                  'YOU',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Colors.green,
                      ),
                ),
          ],
        );
      },
    );
  }
}

part of 'comment.dart';

class _BareCommentWidget extends StatelessWidget {
  const _BareCommentWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CommentHeader(),
            MuffedMarkdownBody(data: state.comment.content),
            const _CommentFooter(),
            ...childrenWidgets(state),
            if (state.comment.childCount > 0 && state.children.isEmpty)
              const _CommentLoadChildrenButton(),
          ],
        );
      },
    );
  }

  List<Widget> childrenWidgets(CommentState state) {
    final organisedComments = organiseCommentsWithChildren(
      state.comment.level + 1,
      state.children,
    );

    return List.generate(organisedComments.length, (index) {
      final key = organisedComments.keys.toList()[index];
      return CommentWidget.tree(
        sortType: state.sortType,
        comment: key,
        children: organisedComments[key]!,
      );
    });
  }
}

/// The button that is displayed when a comment has children that have not
/// yet been loaded, pressing the button loads the children.
class _CommentLoadChildrenButton extends StatelessWidget {
  const _CommentLoadChildrenButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<CommentBloc>().add(
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

class _CommentFooter extends StatelessWidget {
  const _CommentFooter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                context.read<CommentBloc>().add(UpvotePressed());
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
                context.read<CommentBloc>().add(DownvotePressed());
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

class _CommentHeader extends StatelessWidget {
  const _CommentHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
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
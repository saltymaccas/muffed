part of 'comment.dart';

class _TreeCommentView extends StatelessWidget {
  const _TreeCommentView(this.commentState);

  final CommentState commentState;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  left: (state.comment.level == 0)
                      ? BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        )
                      : BorderSide.none,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: _BareCommentWidget(),
              ),
            ),
            if (state.comment.level == 0) const Divider(),
          ],
        );
      },
    );
  }

  List<Widget> childrenWidgets() {
    final organisedChildren = commentState.organisedChildren;
    return organisedChildren.keys.map((LemmyComment key) {
      return CommentWidget.tree(
        comment: key,
        children: organisedChildren[key]!,
        sortType: commentState.sortType,
      );
    }).toList();
  }
}

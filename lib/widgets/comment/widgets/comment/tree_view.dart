part of 'comment.dart';

class _TreeCommentView extends StatelessWidget {
  const _TreeCommentView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  //FIXME:
                  left: (state.comment.comment.path.length > 2)
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
            // FIXME
            if (true) const Divider(),
          ],
        );
      },
    );
  }
}

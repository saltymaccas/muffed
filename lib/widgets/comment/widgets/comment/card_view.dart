part of 'comment.dart';

class _CardCommentView extends StatelessWidget {
  const _CardCommentView({this.trailingPostTitle});

  final Widget? trailingPostTitle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.comment.postTitle,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Row(
                            children: [
                              Text(
                                'In',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.outline,
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
                    if (trailingPostTitle != null) trailingPostTitle!,
                  ],
                ),
              ),
              const Divider(thickness: 0.5),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: _BareCommentWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}

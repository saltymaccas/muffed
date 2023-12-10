import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/pages/inbox/widgets/inbox_item/bloc/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/theme/theme.dart';
import 'package:muffed/widgets/comment/comment.dart';

class InboxReplyItem extends StatelessWidget {
  const InboxReplyItem({required this.item, super.key});

  final LemmyInboxReply item;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReplyItemBloc(read: item.read, repo: context.read<ServerRepo>()),
      child: Builder(
        builder: (context) {
          return BlocConsumer<InboxItemBloc, InboxItemState>(
            listener: (previous, current) {},
            builder: (context, state) {
              return CommentWidget.card(
                comment: item.comment,
                trailingPostTitle: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.done,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class InboxMentionItem extends StatelessWidget {
  const InboxMentionItem({required this.item, super.key});

  final LemmyInboxMention item;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MentionItemBloc(read: item.read, repo: context.read<ServerRepo>()),
      child: Builder(
        builder: (context) {
          return BlocConsumer<InboxItemBloc, InboxItemState>(
            listener: (previous, current) {},
            builder: (context, state) {
              return CommentWidget.card(
                comment: item.comment,
                trailingPostTitle: IconButton(
                  onPressed: () {},
                  icon: state.read
                      ? Icon(
                          Icons.check_circle,
                          color: context.colorScheme.primary,
                        )
                      : const Icon(
                          Icons.check_circle_outline,
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

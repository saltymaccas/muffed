import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/pages/inbox/widgets/inbox_item/bloc/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/theme/theme.dart';
import 'package:muffed/widgets/comment/comment.dart';

class InboxReplyItem extends StatelessWidget {
  const InboxReplyItem({required this.item, required this.sortType, super.key});

  final LemmyInboxReply item;
  final LemmyCommentSortType sortType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReplyItemBloc(item: item, repo: context.read<ServerRepo>()),
      child: Builder(
        builder: (context) {
          return BlocConsumer<ReplyItemBloc, InboxItemState>(
            listener: (previous, current) {},
            builder: (context, state) {
              return CommentWidget.card(
                comment: item.comment,
                sortType: sortType,
                trailingPostTitle: IconButton(
                  onPressed: () {
                    context.read<ReplyItemBloc>().add(ReadStatusToggled());
                  },
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

class InboxMentionItem extends StatelessWidget {
  const InboxMentionItem(
      {required this.item, required this.sortType, super.key,});

  final LemmyInboxMention item;
  final LemmyCommentSortType sortType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MentionItemBloc(item: item, repo: context.read<ServerRepo>()),
      child: Builder(
        builder: (context) {
          return BlocConsumer<MentionItemBloc, InboxItemState>(
            listener: (previous, current) {},
            builder: (context, state) {
              return CommentWidget.card(
                comment: item.comment,
                sortType: sortType,
                trailingPostTitle: IconButton(
                  onPressed: () {
                    context.read<MentionItemBloc>().add(ReadStatusToggled());
                  },
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

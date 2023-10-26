import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/lemmy/models.dart';

import 'bloc/bloc.dart';

class InboxItem extends StatelessWidget {
  const InboxItem({required this.inboxItem, super.key});

  final LemmyComment inboxItem;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InboxItemBloc(),
      child: BlocBuilder<InboxItemBloc, InboxItemState>(
        builder: (context, state) {
          return ListTile(
            title: Text(inboxItem.content),
          );
        },
      ),
    );
  }
}

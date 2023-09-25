import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/repo/lemmy/models.dart';
import 'package:muffed/repo/server_repo.dart';

class MoreMenuButton extends StatelessWidget {
  const MoreMenuButton({required this.post, super.key});

  final LemmyPost post;

  @override
  Widget build(BuildContext context) {
    return MuffedPopupMenuButton(
      icon: const Icon(Icons.more_vert),
      items: [
        MuffedPopupMenuItem(
          title: 'Go to community',
          onTap: () {
            context.push(
              '/home/community?id=${post.communityId}',
            );
          },
        ),
        MuffedPopupMenuItem(
          title: 'Go to user',
          onTap: () {
            context.push(
              '/home/person?id=${post.creatorId}',
            );
          },
        ),
      ],
    );
  }
}

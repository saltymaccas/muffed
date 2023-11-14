import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/lemmy/models.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router.dart';

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
        if (post.body != null)
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
                            post.body!,
                            style: GoogleFonts.robotoMono(
                              textStyle: Theme.of(context).textTheme.bodyMedium,
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
        if (post.creatorId ==
            context.read<GlobalBloc>().getSelectedLemmyAccount()?.id)
          MuffedPopupMenuItem(
            title: 'Edit Post',
            onTap: () {
              context.pushNamed(
                'create_post',
                queryParameters: {},
                extra: CreatePostRouteData(
                  postToBeEdited: post,
                ),
              );
            },
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/lemmy/models/models.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/popup_menu/popup_menu.dart';

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
            // TODO: add navigation
          },
        ),
        MuffedPopupMenuItem(
          title: 'Go to user',
          onTap: () {},
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
            onTap: () {},
          ),
      ],
    );
  }
}

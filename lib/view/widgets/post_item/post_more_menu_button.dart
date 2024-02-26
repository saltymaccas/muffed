import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:muffed/domain/global_state/bloc.dart';
import 'package:muffed/domain/lemmy/models.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/pages/user_screen/user_screen.dart';
import 'package:muffed/view/router/router.dart';
import 'package:muffed/view/pages/community_screen/community_screen.dart';
import 'package:muffed/view/widgets/popup_menu/popup_menu.dart';

class MoreMenuButton extends StatelessWidget {
  const MoreMenuButton({required this.post, super.key});

  final LemmyPost post;

  void onGoToUserPressed(BuildContext context) {
    MNavigator.of(context).pushPage(UserPage(userId: post.creatorId));
  }

  void onGoToCommunityPressed(BuildContext context) {
    MNavigator.of(context)
        .pushPage(CommunityPage(communityId: post.communityId));
  }

  @override
  Widget build(BuildContext context) {
    return MuffedPopupMenuButton(
      icon: const Icon(Icons.more_vert),
      items: [
        MuffedPopupMenuItem(
          title: 'Go to community',
          onTap: () => onGoToCommunityPressed(context),
        ),
        MuffedPopupMenuItem(
          title: 'Go to user',
          onTap: () => onGoToUserPressed(context),
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
        // if (post.creatorId ==
        //     context.read<GlobalBloc>().getSelectedLemmyAccount()?.id)
        //   MuffedPopupMenuItem(
        //     title: 'Edit Post',
        //     onTap: () {
        //       context.pushNamed(
        //         'create_post',
        //         queryParameters: {},
        //         extra: CreatePostRouteData(
        //           postToBeEdited: post,
        //         ),
        //       );
        //     },
        //   ),
      ],
    );
  }
}

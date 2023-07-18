import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/content_view/content_view.dart';
import 'package:muffed/repo/server_repo.dart';
import 'bloc/bloc.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({required this.communityId, this.community, super.key});

  final int communityId;
  final LemmyCommunity? community;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommunityScreenBloc(
        communityId: communityId,
        community: community,
        repo: context.read<ServerRepo>()
      )..add(Initialize()),
      child: BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
        builder: (context, state) {
          return ContentView(
            onPressedPost: (post) {
              context.go('/home/content', extra: post);
            },
            posts: state.posts,
            reachedEnd: () {},
          );
        },
      ),
    );
  }
}

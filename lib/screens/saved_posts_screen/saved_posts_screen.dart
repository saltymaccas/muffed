import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/post_item/post_item.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/screens/saved_posts_screen/bloc/bloc.dart';

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SavedPostsBloc(repo: context.read<ServerRepo>())..add(Initialize()),
      child: BlocBuilder<SavedPostsBloc, SavedPostsState>(
        builder: (context, state) {
          late final Widget contentSliver;

          if (state.status == SavedPostsStatus.success) {
            contentSliver = SliverList.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return PostItem(
                  post: state.posts[index],
                  limitHeight: true,
                );
              },
            );
          } else if (state.status == SavedPostsStatus.loading) {
            contentSliver = const SliverToBoxAdapter(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == SavedPostsStatus.failure) {
            contentSliver = SliverToBoxAdapter(
              child: ErrorComponentTransparent(
                message: state.error,
                retryFunction: () {
                  context.read<SavedPostsBloc>().add(Initialize());
                },
              ),
            );
          } else {
            contentSliver = const SliverToBoxAdapter(
              child: SizedBox(),
            );
          }

          return SetPageInfo(
            indexOfRelevantItem: 2,
            actions: [],
            child: CustomScrollView(
              slivers: [
                const SliverAppBar(
                  title: Text('Saved posts'),
                ),
                contentSliver,
              ],
            ),
          );
        },
      ),
    );
  }
}

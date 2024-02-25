import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/pages/saved_posts/bloc/bloc.dart';
import 'package:muffed/view/widgets/error.dart';
import 'package:muffed/view/widgets/post_item/post_item.dart';
import 'package:muffed/view/widgets/snackbars.dart';

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SavedPostsBloc(repo: context.read<ServerRepo>())..add(Initialize()),
      child: BlocConsumer<SavedPostsBloc, SavedPostsState>(
        listener: (context, state) {
          if (state.error != null) {
            showErrorSnackBar(context, error: state.error);
          }
        },
        builder: (context, state) {
          late final Widget contentSliver;

          if (state.status == SavedPostsStatus.success) {
            contentSliver = SliverList.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return PostItem(
                  post: state.posts[index],
                );
              },
            );
          } else if (state.status == SavedPostsStatus.loading) {
            contentSliver = const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state.status == SavedPostsStatus.failure) {
            contentSliver = SliverToBoxAdapter(
              child: ErrorComponentTransparent(
                error: state.error,
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

          return Stack(
            children: [
              NotificationListener(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 500 &&
                      state.status == SavedPostsStatus.success) {
                    context
                        .read<SavedPostsBloc>()
                        .add(ReachedNearEndOfScroll());
                  }
                  return true;
                },
                child: CustomScrollView(
                  slivers: [
                    const SliverAppBar(
                      floating: true,
                      title: Text('Saved posts'),
                    ),
                    contentSliver,
                  ],
                ),
              ),
              if (state.isLoading)
                const Align(
                  alignment: Alignment.topCenter,
                  child: LinearProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }
}

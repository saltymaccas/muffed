import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/home_page/post_view/card.dart';
import 'bloc/bloc.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen(this.post, {super.key});

  final LemmyPost post;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ContentScreenBloc(repo: context.read<ServerRepo>(), postId: post.id)
            ..add(InitializeEvent()),
      child: BlocBuilder<ContentScreenBloc, ContentScreenState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              const SliverAppBar(
                title: Text('Comments'),
              ),
              SliverToBoxAdapter(
                child: CardLemmyPostItem(
                  post,
                  limitContentHeight: false,
                ),
              ),
              (state.status == ContentScreenStatus.loading)
                  ? const SliverFillRemaining(
                      child: LoadingComponentTransparent(),
                    )
                  : (state.status == ContentScreenStatus.failure)
                      ? const SliverFillRemaining(
                          child: ErrorComponentTransparent(
                            message: 'Failed to load',
                          ),
                        )
                      : (state.status == ContentScreenStatus.initial)
                          ? SliverFillRemaining(
                              child: Container(),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  childCount: state.comments!.length,
                                  (context, index) {
                                return Text(state.comments![index].content);
                              }),
                            ),
            ],
          );
        },
      ),
    );
  }
}

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
          return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  const SliverAppBar(
                    elevation: 2,
                    floating: true,
                    title: Text('Comments'),
                  )
                ];
              },
              body: RefreshIndicator(
                onRefresh: () async {},
                child: NotificationListener(
                    onNotification: (ScrollNotification scrollInfo) {
                      return true;
                    },
                    child: ListView(
                      children: [
                        CardLemmyPostItem(
                          post,
                          limitContentHeight: false,
                        ),
                        Builder(builder: (context) {
                          if (state.status == ContentScreenStatus.loading) {
                            return const LoadingComponentTransparent();
                          } else if (state.status ==
                              ContentScreenStatus.failure) {
                            return const ErrorComponentTransparent();
                          } else if (state.status ==
                              ContentScreenStatus.success) {
                            return Column(
                                children: List.generate(state.comments!.length,
                                    (index) {
                              return Text(state.comments![index].content);
                            }));
                          } else {
                            return Container();
                          }
                        }),
                      ],
                    )),
              ));
        },
      ),
    );
  }
}

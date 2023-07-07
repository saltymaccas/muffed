import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_view/card.dart';
import 'package:server_api/lemmy/models.dart';
import 'package:server_api/server_api.dart';
import 'bloc/bloc.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/components/error.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageBloc(api: context.read<ServerApi>())
        ..add(LoadInitialPostsRequested()),
      child: BlocBuilder<HomePageBloc, HomePageState>(
        buildWhen: (previousState, state) {
          if (previousState.pagesLoaded != state.pagesLoaded) return true;
          if (previousState.status != state.status) return true;
          if (previousState.posts != state.posts) return true;
          return false;
        },
        builder: (context, state) {
          return (state.status == HomePageStatus.loading)
              ? const LoadingComponentTransparent()
              : (state.status == HomePageStatus.failure)
                  ? const ErrorComponentTransparent()
                  : (state.status == HomePageStatus.success)
                      ? FeedView(state)
                      : Container();
        },
      ),
    );
  }
}

class FeedView extends StatefulWidget {
  FeedView(
    this.state, {
    super.key,
  });

  final HomePageState state;

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(handleScrolling);
  }

  void handleScrolling() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !context.read<HomePageBloc>().state.isLoadingMore) {
      context.read<HomePageBloc>().add(ReachedNearEndOfScroll());
    }
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      controller: controller,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            elevation: 2,
            floating: true,
            title: Text('Feed'),
          )
        ];
      },
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomePageBloc>().add(PullDownRefresh());
          await context.read<HomePageBloc>().stream.firstWhere((element) {
            if (element.isRefreshing == false) {
              return true;
            }
            return false;
          });
        },
        child: ListView.builder(
            itemCount: widget.state.posts!.length,
            itemBuilder: (context, index) {
              return CardLemmyPostItem(widget.state.posts![index] as LemmyPost);
            }),
      ),
    );
  }
}

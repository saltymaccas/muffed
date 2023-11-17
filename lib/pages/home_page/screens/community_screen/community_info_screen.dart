import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/widgets/error.dart';
import 'package:muffed/widgets/markdown_body.dart';
import 'package:muffed/widgets/muffed_avatar.dart';
import 'package:muffed/widgets/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/pages/home_page/screens/community_screen/bloc/bloc.dart';
import 'package:muffed/repo/lemmy/models.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../global_state/bloc.dart';

class CommunityInfoScreen extends StatelessWidget {
  const CommunityInfoScreen({required this.bloc, super.key});

  final CommunityScreenBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
        builder: (context, state) {
          switch (state.fullCommunityInfoStatus) {
            case CommunityStatus.initial:
              return const _CommunityInfoInitial();
            case CommunityStatus.loading:
              return const _CommunityInfoLoading();
            case CommunityStatus.failure:
              return _CommunityInfoError(error: state.errorMessage);
            case CommunityStatus.success:
              return _CommunityInfoSuccess(community: state.community!);
          }
        },
      ),
    );
  }
}

class _CommunityInfoSuccess extends StatelessWidget {
  _CommunityInfoSuccess({required this.community})
      : assert(community.isFullyLoaded(), 'Community is not fully loaded');

  final LemmyCommunity community;

  @override
  Widget build(BuildContext context) {
    final countValueTextStyle =
        Theme.of(context).textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            );

    return SetPageInfo(
      actions: const [],
      page: Pages.home,
      child: Scaffold(
        appBar: AppBar(
          title: Text(community.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (community.description != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: MuffedMarkdownBody(
                    data: community.description!,
                  ),
                ),
              const Divider(),
              SizedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.labelLarge,
                              text: 'Posts: ',
                              children: [
                                TextSpan(
                                  text: community.posts.toString(),
                                  style: countValueTextStyle,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.labelLarge,
                              text: 'Comments: ',
                              children: [
                                TextSpan(
                                  text: community.comments.toString(),
                                  style: countValueTextStyle,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.labelLarge,
                              text: 'Subscribers: ',
                              children: [
                                TextSpan(
                                  text: community.subscribers.toString(),
                                  style: countValueTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          RichText(
                            text: TextSpan(
                              text: 'Daily active: ',
                              style: Theme.of(context).textTheme.labelLarge,
                              children: [
                                TextSpan(
                                  text: community.usersActiveDay.toString(),
                                  style: countValueTextStyle,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          RichText(
                            text: TextSpan(
                              text: 'Weekly active: ',
                              style: Theme.of(context).textTheme.labelLarge,
                              children: [
                                TextSpan(
                                  text: community.usersActiveWeek.toString(),
                                  style: countValueTextStyle,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          RichText(
                            text: TextSpan(
                              text: 'Monthly active: ',
                              style: Theme.of(context).textTheme.labelLarge,
                              children: [
                                TextSpan(
                                  text: community.usersActiveMonth.toString(),
                                  style: countValueTextStyle,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Moderators:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (community.moderators!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final moderator in community.moderators!)
                        ActionChip(
                          label: Text(moderator.name),
                          avatar: MuffedAvatar(
                            url: moderator.avatar,
                          ),
                          onPressed: () {
                            context.pushNamed(
                              'person',
                              queryParameters: {
                                'id': moderator.id.toString(),
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              const Divider(),
              if (context.read<GlobalBloc>().isLoggedIn())
                Skeletonizer(
                  enabled: community.blocked == null,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CommunityScreenBloc>().add(
                              BlockToggled(),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        (community.blocked == null)
                            ? 'Placeholder'
                            : (community.blocked!)
                                ? 'Unblock Community'
                                : 'Block Community',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityInfoInitial extends StatelessWidget {
  const _CommunityInfoInitial();

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class _CommunityInfoLoading extends StatelessWidget {
  const _CommunityInfoLoading();

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}

class _CommunityInfoError extends StatelessWidget {
  const _CommunityInfoError({this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return ErrorComponentTransparent(
      error: error,
      retryFunction: () {
        context.read<CommunityScreenBloc>().add(Initialize());
      },
    );
  }
}

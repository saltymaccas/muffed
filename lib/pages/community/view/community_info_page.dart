import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/db/db.dart';
import 'package:muffed/pages/community/community.dart';
import 'package:muffed/pages/user/user.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/models/models.dart';
import 'package:muffed/widgets/markdown_body.dart';
import 'package:muffed/widgets/muffed_avatar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommunityInfoPage extends MPage<void> {
  CommunityInfoPage({
    int? communityId,
    String? communityName,
    this.bloc,
    this.community,
  })  : communityId = communityId ?? community?.id,
        communityName = communityName ?? community?.name,
        assert(
          communityId != null ||
              communityName != null ||
              community != null ||
              bloc != null,
          'No community defined',
        ),
        super(pageActions: PageActions([]));

  /// The community ID
  final int? communityId;

  /// The community name
  final String? communityName;

  /// The community object which contains the community information.
  ///
  /// If this is set to null the information will be loaded from the API.
  /// Setting the value will mean the community information can be shown
  /// instantly
  final LemmyCommunity? community;

  final CommunityScreenBloc? bloc;

  @override
  Widget build(BuildContext context) {
    if (bloc != null) {
      return BlocProvider.value(value: bloc!, child: const CommunityInfoView());
    } else {
      return BlocProvider(
        create: (context) => CommunityScreenBloc(
          community: community,
          repo: context.read<ServerRepo>(),
        )..add(InitialiseCommunityScreen()),
        child: const CommunityInfoView(),
      );
    }
  }
}

/// TODO: add better handling of community status

class CommunityInfoView extends StatelessWidget {
  const CommunityInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
      builder: (context, state) {
        switch (state.fullCommunityInfoStatus) {
          case CommunityStatus.initial:
            return const _CommunityInfoInitial();
          case CommunityStatus.loading:
            return const _CommunityInfoLoading();
          case CommunityStatus.failure:
            return _CommunityInfoError(state.exception!);
          case CommunityStatus.success:
            return _CommunityInfoSuccess(community: state.community!);
        }
      },
    );
  }
}

class _CommunityInfoSuccess extends StatelessWidget {
  _CommunityInfoSuccess({required this.community})
      : assert(community.isFullyLoaded, 'Community is not fully loaded');

  final LemmyCommunity community;

  @override
  Widget build(BuildContext context) {
    final countValueTextStyle =
        Theme.of(context).textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            );

    return Scaffold(
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
                          identiconID: moderator.name,
                        ),
                        onPressed: () {
                          context.pushPage(
                            UserPage(
                              userId: moderator.id,
                              username: moderator.name,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            const Divider(),
            if (context.read<DB>().state.isLoggedIn)
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
  const _CommunityInfoError(this.exception);

  final MException exception;

  @override
  Widget build(BuildContext context) {
    return ExceptionWidget(
      exception: exception,
      retryFunction: () {
        context.read<CommunityScreenBloc>().add(InitialiseCommunityScreen());
      },
    );
  }
}

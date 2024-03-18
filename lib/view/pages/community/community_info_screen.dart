import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/domain/global_state/bloc.dart';
import 'package:muffed/domain/lemmy/models.dart';
import 'package:muffed/view/pages/community/bloc/bloc.dart';
import 'package:muffed/view/pages/user_screen/user_screen.dart';
import 'package:muffed/view/router/navigator/navigator.dart';
import 'package:muffed/view/widgets/markdown_body.dart';
import 'package:muffed/view/widgets/muffed_avatar.dart';
import 'package:muffed/view/widgets/nullable_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommunityInfoScreen extends StatelessWidget {
  const CommunityInfoScreen({required this.bloc, super.key});

  final CommunityBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      bloc: bloc,
      builder: (context, state) => _CommunityInfo(
        title: state.title,
        description: state.description,
        postsCount: state.counts?.posts,
        commentsCount: state.counts?.comments,
        subscribersCount: state.counts?.subscribers,
        dailyActiveCount: state.counts?.usersActiveDay,
        weeklyActiveCount: state.counts?.usersActiveWeek,
        monthlyActiveCount: state.counts?.usersActiveMonth,
      ),
    );
  }
}

class _CommunityInfo extends StatelessWidget {
  _CommunityInfo({
    this.title,
    this.description,
    this.postsCount,
    this.commentsCount,
    this.subscribersCount,
    this.dailyActiveCount,
    this.monthlyActiveCount,
    this.weeklyActiveCount,
    this.onBlockPressed,
  });

  final String? title;
  final String? description;
  final int? postsCount;
  final int? commentsCount;
  final int? subscribersCount;
  final int? dailyActiveCount;
  final int? weeklyActiveCount;
  final int? monthlyActiveCount;

  final void Function()? onBlockPressed;

  void onModeratorPressed(BuildContext context, int id) {
    MNavigator.of(context).pushPage(UserPage(userId: id));
  }

  String get placeholderDescription =>
      '''Lorem ipsum dolor sit amet, officia excepteur ex fugiat reprehenderit enim labore culpa sint ad nisi Lorem pariatur mollit ex esse exercitation amet. Nisi anim cupidatat excepteur officia. Reprehenderit nostrud nostrud ipsum Lorem est aliquip amet voluptate voluptate dolor minim nulla est proident. Nostrud officia pariatur ut officia. Sit irure elit esse ea nulla sunt ex occaecat reprehenderit commodo officia dolor Lorem duis laboris cupidatat officia voluptate. Culpa proident adipisicing id nulla nisi laboris ex in Lorem sunt duis officia eiusmod. Aliqua reprehenderit commodo ex non excepteur duis sunt velit enim. Voluptate laboris sint cupidatat ullamco ut ea consectetur et est culpa et culpa duis.''';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final countValueTextStyle = theme.textTheme.labelLarge!.copyWith(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    );

    final countKeyTextStyle = theme.textTheme.labelMedium;

    return Scaffold(
      appBar: AppBar(
        title: NullableBuilder(
          value: title,
          placeholderValue: 'lorem ipsum',
          builder: (context, value) => Text(value),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NullableBuilder(
              value: description,
              placeholderValue: placeholderDescription,
              builder: (context, value) => MuffedMarkdownBody(data: value),
            ),
            const Divider(),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Text(
                              'subscribers: ',
                              style: countKeyTextStyle,
                            ),
                            NullableBuilder(
                              value: subscribersCount,
                              placeholderValue: 9999,
                              builder: (context, value) => Text(
                                value.toString(),
                                style: countValueTextStyle,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('posts: ', style: countKeyTextStyle),
                            NullableBuilder(
                              value: postsCount,
                              placeholderValue: 9999,
                              builder: (context, value) => Text(
                                value.toString(),
                                style: countValueTextStyle,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('comments: ', style: countKeyTextStyle),
                            NullableBuilder(
                              value: commentsCount,
                              placeholderValue: 9999,
                              builder: (context, value) => Text(
                                value.toString(),
                                style: countValueTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Text(
                              'active daily: ',
                              style: countKeyTextStyle,
                            ),
                            NullableBuilder(
                              value: dailyActiveCount,
                              placeholderValue: 9999,
                              builder: (context, value) => Text(
                                value.toString(),
                                style: countValueTextStyle,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('active weekly: ', style: countKeyTextStyle),
                            NullableBuilder(
                              value: weeklyActiveCount,
                              placeholderValue: 9999,
                              builder: (context, value) => Text(
                                value.toString(),
                                style: countValueTextStyle,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('active monthly: ', style: countKeyTextStyle),
                            NullableBuilder(
                              value: monthlyActiveCount,
                              placeholderValue: 9999,
                              builder: (context, value) => Text(
                                value.toString(),
                                style: countValueTextStyle,
                              ),
                            ),
                          ],
                        ),
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
          ],
        ),
      ),
    );
  }
}

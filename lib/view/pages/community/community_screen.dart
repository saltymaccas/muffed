import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/pages/community/bloc/bloc.dart';
import 'package:muffed/view/pages/community/bloc/scroll/scroll.dart';
import 'package:muffed/view/pages/community/community_info_screen.dart';
import 'package:muffed/view/pages/community/widgets/header.dart';
import 'package:muffed/view/router/models/page.dart';
import 'package:muffed/view/router/navigator/navigator.dart';
import 'package:muffed/view/widgets/content_scroll_view/content_scroll_view.dart';
import 'package:muffed/view/widgets/content_scroll_view/view/view.dart';
import 'package:muffed/view/widgets/muffed_avatar.dart';
import 'package:muffed/view/widgets/nullable_builder.dart';
import 'package:muffed/view/widgets/post_item/post_item.dart';
import 'package:muffed/view/widgets/snackbars.dart';

export 'models/models.dart';

class CommunityPage extends MPage<void> {
  CommunityPage({
    this.communityId,
    this.communityName,
  });

  final int? communityId;
  final String? communityName;

  @override
  Widget build(BuildContext context) {
    return CommunityScreen(
      communityId: communityId,
      communityName: communityName,
    );
  }
}

/// Displays a specified community and its posts
class CommunityScreen extends StatefulWidget {
  /// initialize
  const CommunityScreen({
    this.communityId,
    this.communityName,
    super.key,
  }) : assert(
          communityId != null || communityName != null,
          'No community defined',
        );

  /// The community ID
  final int? communityId;

  /// The community name
  final String? communityName;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late final CommunityBloc communityBloc;
  late final CommunityScrollBloc scrollBloc;

  @override
  void initState() {
    super.initState();

    final lemmyRepo = context.read<ServerRepo>().lemmyRepo;

    communityBloc = CommunityBloc(
      lemmyRepo: lemmyRepo,
      communityId: widget.communityId,
      communityName: widget.communityName,
    )
      ..add(Initialised())
      ..stream.listen(communityBlocListener);

    scrollBloc = CommunityScrollBloc(
      lemmyRepo: lemmyRepo,
      communityId: widget.communityId!,
    )
      ..add(ScrollInitialised())
      ..stream.listen(scrollBlocListener);
  }

  void communityBlocListener(CommunityState event) {
    if (event.status == CommunityStatus.failure) {
      onError(context: context, errorMessage: event.errorMessage);
    }
  }

  void scrollBlocListener(CommunityScrollState event) {
    if (event.status == PagedScrollViewStatus.failure) {
      onError(context: context, errorMessage: event.errorMessage);
    }
  }

  void onError({required BuildContext context, String? errorMessage}) {
    ScaffoldMessenger.of(context).showSnackBar(
      ErrorSnackBar(
        context: context,
        errorMessage: errorMessage,
      ),
    );
  }

  void pushCommunityInfoPage(BuildContext context) {
    MNavigator.of(context).pushPage(
      MaterialPage(child: CommunityInfoScreen(bloc: communityBloc)),
    );
  }

  void onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void loadMoreCallback() {
    scrollBloc.add(ScrollEndReached());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<CommunityScrollBloc, CommunityScrollState>(
        bloc: scrollBloc,
        builder: (context, state) {
          return PagedScroll(
            headerSlivers: [
              BlocBuilder<CommunityBloc, CommunityState>(
                bloc: communityBloc,
                builder: (context, state) {
                  return SliverPersistentHeader(
                    pinned: true,
                    delegate: CommunityPageViewHeaderDelegate(
                      banner: (state.banner != null)
                          ? ExtendedImage.network(
                              state.banner!,
                              fit: BoxFit.cover,
                              width: double.maxFinite,
                              height: double.maxFinite,
                            )
                          : ExtendedImage(
                              fit: BoxFit.cover,
                              width: double.maxFinite,
                              height: double.maxFinite,
                              image: const AssetImage(
                                'assets/placeholder_banner.jpeg',
                              ),
                            ),
                      body: _HeaderBody(
                        icon: state.icon,
                        title: state.title,
                        name: state.name,
                        siteName: state.site?.name,
                        banner: state.banner,
                        subscribers: state.counts?.subscribers,
                        numActive: state.counts?.usersActiveDay,
                        description: state.description,
                        onViewCommunityInfoPressed: () =>
                            pushCommunityInfoPage(context),
                      ),
                      topBarBuilder: (context, shrinkOffset) => _TopBar(
                        shrinkOffset: shrinkOffset,
                        title: state.title,
                        icon: state.icon,
                        onBackPressed: () => onBackPressed(context),
                      ),
                    ),
                  );
                },
              ),
            ],
            status: state.status,
            items: state.posts,
            loadMoreCallback: loadMoreCallback,
            itemBuilder: (context, item) {
              if (item is LemmyPost) {
                return PostItem(post: item);
              } else {
                return SizedBox(
                  height: 200,
                  width: 200,
                  child: Placeholder(
                    child: Text(
                      'widget err: item of ${item.runtimeType} type not recognised',
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar(
      {required this.shrinkOffset, this.title, this.icon, this.onBackPressed});

  final double shrinkOffset;
  final String? title;
  final String? icon;

  final void Function()? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBackPressed,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Opacity(
              opacity: shrinkOffset,
              child: Row(
                children: [
                  NullableBuilder(
                    value: title,
                    placeholderValue: 'lorem ipsum',
                    builder: (context, value) =>
                        Text(value, style: theme.textTheme.titleMedium),
                  ),
                  const SizedBox(width: 8),
                  MuffedAvatar(
                    radius: 15,
                    url: icon,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBody extends StatelessWidget {
  const _HeaderBody({
    this.icon,
    this.title,
    this.name,
    this.siteName,
    this.banner,
    this.subscribers,
    this.numActive,
    this.description,
    this.onViewCommunityInfoPressed,
  });

  final String? icon;
  final String? title;
  final String? name;
  final String? siteName;
  final String? banner;
  final int? subscribers;
  final int? numActive;
  final String? description;

  final void Function()? onViewCommunityInfoPressed;

  String? get tag {
    if (name == null || siteName == null) return null;
    return '!$name@$siteName'.toLowerCase();
  }

  String get placeholderDescription => '''
      Lorem ipsum dolor sit amet, 
      officia excepteur ex fugiat reprehenderit enim labore 

      culpa sint ad nisi Lorem pariatur mollit ex esse exercitation amet. Nisi anim cupidatat excepteur officia. Reprehenderit nostrud nostrud ipsum Lorem est aliquip amet voluptate voluptate dolor minim nulla est proident. Nostrud officia pariatur ut officia. Sit irure elit esse ea nulla sunt ex occaecat reprehenderit commodo officia dolor Lorem duis laboris cupidatat officia voluptate. Culpa proident adipisicing id nulla nisi laboris ex in Lorem sunt duis officia eiusmod. Aliqua reprehenderit commodo ex non excepteur duis sunt velit enim. Voluptate laboris sint cupidatat ullamco ut ea consectetur et est culpa et culpa duis.''';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              NullableBuilder(
                value: icon,
                placeholderValue: null,
                builder: (context, value) {
                  return MuffedAvatar(
                    url: value,
                  );
                },
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NullableBuilder(
                    value: title,
                    placeholderValue: 'community',
                    builder: (context, value) => Text(
                      value,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  NullableBuilder(
                    value: tag,
                    placeholderValue: 'Lorem ipsum',
                    builder: (context, value) {
                      return Text(
                        value,
                        style: theme.textTheme.labelSmall!
                            .copyWith(color: theme.colorScheme.outline),
                      );
                    },
                  ),
                  Row(
                    children: [
                      NullableBuilder(
                        value: subscribers,
                        placeholderValue: '9999 members',
                        builder: (context, value) => Text(
                          '$value members',
                          style: theme.textTheme.labelMedium!.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        child: Center(
                          child: Container(
                            width: 4,
                            height: 10,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.outlineVariant,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      NullableBuilder(
                        value: numActive,
                        placeholderValue: '9999 active',
                        builder: (context, value) => Text(
                          '$value active',
                          style: theme.textTheme.labelMedium!.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: NullableBuilder(
              value: description,
              placeholderValue: placeholderDescription,
              builder: (context, value) => Text(
                value,
                style: theme.textTheme.bodySmall,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: onViewCommunityInfoPressed,
              child: const Text('view community info'),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/db/db.dart';
import 'package:muffed/interfaces/lemmy/models/placeholders.dart';
import 'package:muffed/pages/.community/community.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/theme/models/extentions.dart';
import 'package:muffed/widgets/content_scroll/content_scroll.dart';
import 'package:muffed/widgets/image.dart';
import 'package:muffed/widgets/markdown_body.dart';
import 'package:muffed/widgets/muffed_avatar.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../interfaces/lemmy/lemmy.dart';

/// Displays a specified community and its posts
class CommunityDisplay extends StatelessWidget {
  const CommunityDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
      builder: (context, state) {
        final blocContext = context;

        final communityBloc = BlocProvider.of<CommunityScreenBloc>(blocContext);

        if (state.communityStatus == CommunityStatus.failure) {
          return ExceptionWidget(
            exception: state.exception!,
            retryFunction: () {
              context
                  .read<CommunityScreenBloc>()
                  .add(InitialiseCommunityScreen());
            },
          );
        }

        return Scaffold(
          body: ContentScrollView(
            headerSlivers: [
              SliverPersistentHeader(
                delegate: _TopBarDelegate(
                  communityView: state.communityView,
                  bloc: communityBloc,
                ),
                pinned: true,
              ),
            ],
            builderDelegate: LemmyPostContentBuilderDelegate(),
          ),
        );
      },
    );
  }
}

// TODO: add error handling
class _TopBarDelegate extends SliverPersistentHeaderDelegate {
  _TopBarDelegate({
    required this.bloc,
    CommunityView? communityView,
  })  : usingPlaceholder = communityView == null,
        communityView = communityView ?? communityViewPlaceHolder;

  final CommunityView communityView;

  final bool usingPlaceholder;

  final CommunityScreenBloc bloc;

  double get headerMaxHeight => 400;

  double get headerMinHeight => 90;

  double get bannerEnd => 0.5;

  Curve get opacityCurve => Curves.easeInOutQuart;

  @override
  double get maxExtent => headerMaxHeight;

  @override
  double get minExtent => headerMinHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final fractionScrolled = shrinkOffset / headerMaxHeight;

    final placeholderBanner = ExtendedImage.asset(
      'assets/placeholder_banner.jpeg',
      height: (headerMaxHeight - shrinkOffset) * bannerEnd,
      width: double.maxFinite,
      fit: BoxFit.cover,
    );
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Skeletonizer(
        key: ValueKey(usingPlaceholder),
        enabled: usingPlaceholder,
        ignoreContainers: true,
        child: Material(
          clipBehavior: Clip.hardEdge,
          color: Theme.of(context).colorScheme.surface,
          elevation: 5,
          child: Stack(
            children: [
              // displays community info and banner
              Offstage(
                offstage: fractionScrolled == 1,
                child: Stack(
                  children: [
                    // banner
                    if (!usingPlaceholder)
                      ShaderMask(
                        shaderCallback: (rect) {
                          return const LinearGradient(
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black, Colors.transparent],
                          ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height),
                          );
                        },
                        blendMode: BlendMode.dstIn,
                        child: (communityView.community.banner != null)
                            ? MuffedImage(
                                height: (headerMaxHeight - shrinkOffset) *
                                    bannerEnd,
                                width: double.maxFinite,
                                fit: BoxFit.cover,
                                imageUrl: communityView.community.banner!,
                              )
                            : placeholderBanner,
                      ),
                    // sizes to the height the the header
                    SizedBox(
                      height: headerMaxHeight - shrinkOffset,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // sizes from bottom up to the fraction chosen
                          // of the header
                          SizedBox(
                            height: (headerMaxHeight - shrinkOffset) *
                                (1 - (bannerEnd - 0.05)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // title
                                  Row(
                                    children: [
                                      MuffedAvatar(
                                        url: communityView.community.icon,
                                        identiconID: communityView.community.name,
                                        radius: 34,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              communityView.community .title,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                            Text(
                                            // replace with tag
                                            communityView.community.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                  ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: communityView.counts.subscribers
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .outline,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text: ' members',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .outline,
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text: ' ⋅ ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .outline,
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text:communityView .counts
                                                        .usersActiveDay
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .outline,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text: ' active',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .outline,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (communityView.community.description != null)
                                    Builder(
                                      builder: (context) {
                                        // gets only the first paragraph
                                        final matches = RegExp(
                                          r'^.*?\n',
                                          dotAll: true,
                                        ).firstMatch(communityView.community.description!);

                                        final text = matches?.group(0) ??
                                            communityView.community.description!;

                                        return MuffedMarkdownBody(
                                          maxHeight: 104,
                                          data: text,
                                        );
                                      },
                                    ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          context.pushPage(
                                            CommunityInfoPage(
                                              communityView: communityView,
                                            ),
                                          );
                                        },
                                        child: const Text('See community info'),
                                      ),
                                      if (context.db.state.auth.lemmy.loggedIn)
                                        TextButton(
                                          onPressed: () {
                                            context
                                                .read<CommunityScreenBloc>()
                                                .add(ToggledSubscribe());
                                          },
                                          style: (communityView.subscribed ==
                                                  SubscribedType
                                                      .notSubscribed)
                                              ? TextButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primaryContainer,
                                                  foregroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .onPrimaryContainer,
                                                )
                                              : TextButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .outline,
                                                  foregroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .outlineVariant,
                                                ),
                                          child: (communityView.subscribed ==
                                                  SubscribedType
                                                      .subscribed)
                                              ? const Text('Unsubscribe')
                                              : (communityView.subscribed ==
                                                      SubscribedType
                                                          .notSubscribed)
                                                  ? const Text('Subscribe')
                                                  : const Text('Pending'),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IgnorePointer(
                child: Container(
                  height: clampDouble(
                    headerMaxHeight - shrinkOffset,
                    headerMinHeight,
                    headerMaxHeight,
                  ),
                  width: double.maxFinite,
                  color: context.colorScheme.surface.withOpacity(
                    opacityCurve.transform(fractionScrolled),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Skeleton.keep(
                              child: IconButton(
                                onPressed: () {
                                  context.pop();
                                },
                                icon: const Icon(Icons.arrow_back),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Opacity(
                              opacity: opacityCurve.flipped
                                  .transform(fractionScrolled),
                              child: Row(
                                children: [
                                  MuffedAvatar(
                                    url: communityView.community.icon,
                                    identiconID: communityView.community.name,
                                    radius: 16,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    communityView.community.title,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

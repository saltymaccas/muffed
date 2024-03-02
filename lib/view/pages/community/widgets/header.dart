import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:muffed/domain/lemmy/models.dart';
import 'package:muffed/view/widgets/image.dart';
import 'package:muffed/view/widgets/markdown_body.dart';
import 'package:muffed/view/widgets/muffed_avatar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SliverCommunityPageViewHeader extends StatelessWidget {
  const SliverCommunityPageViewHeader({
    this.community,
    this.authenticated = false,
    this.onSubscribeTapped,
    this.openCommunityInfo,
    super.key,
  });

  final LemmyCommunity? community;
  final bool authenticated;
  final void Function()? onSubscribeTapped;
  final void Function()? openCommunityInfo;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _CommunityPageViewHeaderDelegate(
        community: community,
        authenticated: authenticated,
        onSubscribeTapped: onSubscribeTapped,
        openCommunityInfo: openCommunityInfo,
      ),
    );
  }
}

class _CommunityPageViewHeaderDelegate extends SliverPersistentHeaderDelegate {
  _CommunityPageViewHeaderDelegate({
    LemmyCommunity? community,
    this.authenticated = false,
    this.onSubscribeTapped,
    this.openCommunityInfo,
  })  : isLoading = community == null,
        community = community ?? LemmyCommunity.placeHolder();

  final LemmyCommunity community;
  final bool isLoading;
  final bool authenticated;
  final void Function()? onSubscribeTapped;
  final void Function()? openCommunityInfo;

  double get headerMaxHeight => 400;
  double get headerMinHeight => 90;
  double get bannerEnd => 0.5;

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
        key: ValueKey(isLoading),
        enabled: isLoading,
        ignoreContainers: true,
        child: Material(
          clipBehavior: Clip.hardEdge,
          color: Theme.of(context).colorScheme.surface,
          elevation: 5,
          child: Stack(
            children: [
              Opacity(
                opacity: 1 - fractionScrolled,
                child: Stack(
                  children: [
                    // banner
                    if (!isLoading)
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
                        child: (community.banner != null)
                            ? SizedBox(
                                height: (headerMaxHeight - shrinkOffset) *
                                    bannerEnd,
                                child: MuffedImage(
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                  imageUrl: community.banner!,
                                ),
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
                                        url: community.icon,
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
                                              community.title,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                            Text(
                                              community.tag,
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
                                                    text: community.subscribers
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
                                                    text: community
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
                                  if (community.description != null)
                                    Builder(
                                      builder: (context) {
                                        // gets only the first paragraph
                                        final matches = RegExp(
                                          r'^.*?\n',
                                          dotAll: true,
                                        ).firstMatch(community.description!);

                                        final text = matches?.group(0) ??
                                            community.description!;

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
                                        onPressed: openCommunityInfo,
                                        child: const Text('See community info'),
                                      ),
                                      if (authenticated)
                                        TextButton(
                                          onPressed: onSubscribeTapped,
                                          style: (community.subscribed ==
                                                  LemmySubscribedType
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
                                          child: (community.subscribed ==
                                                  LemmySubscribedType
                                                      .subscribed)
                                              ? const Text('Unsubscribe')
                                              : (community.subscribed ==
                                                      LemmySubscribedType
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
              SizedBox(
                height: headerMaxHeight - shrinkOffset,
                width: double.maxFinite,
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
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Opacity(
                              opacity:
                                  Curves.easeInCirc.transform(fractionScrolled),
                              child: Row(
                                children: [
                                  MuffedAvatar(url: community.icon, radius: 16),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    community.title,
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

import 'package:flutter/material.dart';
import 'package:muffed/domain/lemmy/models.dart';

class CommunityPageViewHeaderDelegate extends SliverPersistentHeaderDelegate {
  CommunityPageViewHeaderDelegate({
    this.headerMaxHeight = 400,
    this.headerMinHeight = 90,
    this.bannerEnd = 0.5,
    this.banner,
    this.body,
    this.topBarBuilder,
  });

  final Widget? banner;
  final Widget? body;
  final Widget Function(BuildContext context, double shrinkFaction)?
      topBarBuilder;

  final double headerMaxHeight;
  final double headerMinHeight;
  final double bannerEnd;

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

    return Material(
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.surface,
      elevation: 5,
      child: Stack(
        children: [
          Opacity(
            opacity: 1 - fractionScrolled,
            child: Stack(
              children: [
                if (banner != null)
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
                    child: SizedBox(
                      height: (headerMaxHeight - shrinkOffset) * bannerEnd,
                      child: banner,
                    ),
                  ),
                // sizes to the height of the header
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
                        child: body,
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
          if (topBarBuilder != null) topBarBuilder!(context, fractionScrolled),
        ],
      ),
    );
  }
}

class _SubscribeButton extends StatelessWidget {
  const _SubscribeButton({
    required this.subscribedType,
    required this.onPressed,
  });

  final LemmySubscribedType subscribedType;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    late final String text;
    late final ButtonStyle buttonStyle;

    switch (subscribedType) {
      case LemmySubscribedType.subscribed:
        text = 'Subscibed';
        buttonStyle = TextButton.styleFrom(
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.onPrimaryContainer,
        );
      case LemmySubscribedType.pending:
        text = 'Pending';
        buttonStyle = TextButton.styleFrom(
          backgroundColor: theme.colorScheme.outline,
          foregroundColor: theme.colorScheme.outlineVariant,
        );
      case LemmySubscribedType.notSubscribed:
        text = 'Subscribe';
        buttonStyle = TextButton.styleFrom(
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.onPrimaryContainer,
        );
    }

    return TextButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Text(text),
    );
  }
}

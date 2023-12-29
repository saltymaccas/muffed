part of 'user_page.dart';

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate({LemmyUser? user})
      : usingPlaceHolderData = user == null,
        user = user ?? LemmyUser.placeHolder();

  @override
  double get maxExtent => _headerMaxHeight;

  @override
  double get minExtent => _headerMinHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  final bool usingPlaceHolderData;
  final LemmyUser user;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final placeholderBanner = Image.asset(
      'assets/placeholder_banner.jpeg',
      height: (_headerMaxHeight - shrinkOffset) * _bannerEndFraction,
      width: double.maxFinite,
      fit: BoxFit.cover,
    );

    return Skeletonizer(
      enabled: usingPlaceHolderData,
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          clipBehavior: Clip.hardEdge,
          color: Theme.of(context).colorScheme.surface,
          elevation: 5,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Stack(
                  children: [
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
                      child: (user.banner != null)
                          ? MuffedImage(
                              fit: BoxFit.cover,
                              width: double.maxFinite,
                              height: (_headerMaxHeight - shrinkOffset) *
                                  _bannerEndFraction,
                              imageUrl: user.banner!,
                            )
                          : placeholderBanner,
                    ),
                    SizedBox(
                      height: _headerMaxHeight - shrinkOffset,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 16,
                            ),
                            child: MuffedAvatar(
                              url: user.avatar,
                            ),
                          ),
                          SizedBox(
                            height: (_headerMaxHeight - shrinkOffset) *
                                (1 - _bannerEndFraction),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(user.getTag()),
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
              Container(
                height: _headerMaxHeight - shrinkOffset,
                width: double.maxFinite,
                color: Theme.of(context).colorScheme.surface.withOpacity(
                      shrinkOffset / (_headerMaxHeight - _headerMinHeight),
                    ),
              ),
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Opacity(
                          opacity: shrinkOffset /
                              (_headerMaxHeight - _headerMinHeight),
                          child: Text(
                            user.name,
                            style: context.textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                    const TabBar(
                      tabs: [
                        Tab(
                          text: 'About',
                        ),
                        Tab(
                          text: 'Posts',
                        ),
                        Tab(
                          text: 'Comments',
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

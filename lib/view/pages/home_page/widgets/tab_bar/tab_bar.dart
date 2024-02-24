import 'package:flutter/material.dart';

class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  SliverTabBarDelegate({
    required this.tabs,
    required this.selectedTab,
    required this.tabTapCallback,
  });

  final List<String> tabs;
  final int selectedTab;
  final void Function(int index) tabTapCallback;

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverTabBarDelegate oldDelegate) {
    return oldDelegate.tabs != tabs || oldDelegate.selectedTab != selectedTab;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(
      height: 40,
      child: Column(
        children: [
          SizedBox(
            height: 39,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (context, index) => PageTab(
                name: tabs[index],
                selected: selectedTab == index,
                onTap: () => tabTapCallback(index),
              ),
            ),
          ),
          Container(
            height: 1,
            width: double.maxFinite,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}

class PageTab extends StatelessWidget {
  const PageTab({
    required this.name,
    required this.selected,
    this.onTap,
    super.key,
  });

  final String name;
  final bool selected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: selected
            ? Theme.of(context).colorScheme.inverseSurface
            : Theme.of(context).colorScheme.surfaceVariant,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: InkWell(
          splashColor: !selected
              ? Theme.of(context).colorScheme.inverseSurface
              : Theme.of(context).colorScheme.surfaceVariant,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Text(
              name,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: selected
                        ? Theme.of(context).colorScheme.onInverseSurface
                        : Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

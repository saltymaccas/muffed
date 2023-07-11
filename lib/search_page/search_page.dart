import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(delegate: _SearchDelegate())
          ],
        ));
  }
}

class _SearchDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 200.0;

  @override
  double get maxExtent => 200.0;

  @override
  bool shouldRebuild(_SearchDelegate oldDelegate) => false;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent){
    return TextField();
  }
}

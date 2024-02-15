import 'package:muffed/domain/lemmy.dart';
import 'package:muffed/domain/server_repo.dart';

import 'controller.dart';
import 'package:flutter/material.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView({
    required this.contentType,
    required this.sortType,
    required this.lemmyRepo,
    super.key,
  });

  final ContentType contentType;
  final LemmySortType sortType;
  final LemmyRepo lemmyRepo;

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  late final HomeTabViewController<LemmyPost> controller;

  @override
  void initState() {
    super.initState();
    controller = HomeTabViewController(lemmyRepo: widget.lemmyRepo);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

import 'package:flutter/material.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SetPageInfo(actions: [], itemIndex: 1,child: const Placeholder());
  }
}

import 'package:flutter/material.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SetPageInfo(
        itemIndex: 2,
        actions: [],
        child: const Placeholder(
          color: Colors.blue,
        ));
  }
}

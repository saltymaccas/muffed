import 'package:flutter/material.dart';
import 'package:muffed/navigation_bar/navigation_bar.dart';

class MNavigationBar extends StatelessWidget {
  const MNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NavigationBarItem(
            relatedBranchIndex: 0,
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
          ),
          NavigationBarItem(
            relatedBranchIndex: 1,
            icon: Icons.inbox_outlined,
            selectedIcon: Icons.inbox,
          ),
          NavigationBarItem(
            relatedBranchIndex: 2,
            icon: Icons.account_circle_outlined,
            selectedIcon: Icons.account_circle,
          ),
        ],
      ),
    );
  }
}

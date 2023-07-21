import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SetPageInfo(
        itemIndex: 2,
        actions: [],
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                size: 100,
              ),
              TextButton(onPressed: () {
                showModalBottomSheet(context: context, builder: (context) {
                  return Container();
                });
              }, child: Text('Anonymous'))
            ],
          ),
        ));
  }
}

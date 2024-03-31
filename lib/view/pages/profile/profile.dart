import 'package:flutter/material.dart';
import 'package:muffed/view/pages/key_manager/key_manager.dart';
import 'package:muffed/view/router/router.dart';
import 'package:muffed/view/smart_widgets/app_options.dart';
import 'package:muffed/view/smart_widgets/key_manager.dart';

class ProfilePage extends MPage<void> {
  ProfilePage();

  @override
  Widget build(BuildContext context) {
    return const ProfilePageView();
  }
}

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  void onSwapKeyPressed(BuildContext context) {
    MNavigator.of(context)
        .pushPage(MuffedPage<void>(builder: (context) => KeyManagerPage()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleTheme = theme.textTheme.titleLarge;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Text('App Options', style: titleTheme),
            ),
            const AppOptions(),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
              ),
              child: Text('Keys', style: titleTheme),
            ),
            KeyManager(
              onSwapKeyPressed: () => onSwapKeyPressed(context),
            ),
          ],
        ),
      ),
    );
  }
}

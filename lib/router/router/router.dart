import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/navigation_bar/navigation_bar.dart';
import 'package:muffed/pages/home/home.dart';
import 'package:muffed/pages/inbox/inbox.dart';
import 'package:muffed/pages/profile/profile.dart';
import 'package:muffed/router/router.dart';

part 'router_delegate.dart';

class MRouterConfig extends RouterConfig<MPage<Object?>> {
  MRouterConfig({
    required this.navigator,
    required super.routerDelegate,
    super.backButtonDispatcher,
    super.routeInformationParser,
    super.routeInformationProvider,
  });

  factory MRouterConfig.create() {
    final navigator = MNavigator(
      MNavigatorState(
        currentBranchIndex: 0,
        rootBranch: Branch(
          const [],
        ),
        branches: [
          Branch(
            [HomePage()],
          ),
          Branch(
            [InboxPage()],
          ),
          Branch(
            const [ProfilePage()],
          ),
        ],
      ),
    );

    navigator.pushToRootBranch(_RootPage(navigator));

    return MRouterConfig(
      navigator: navigator,
      routerDelegate: MRouterDelegate(navigator),
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }

  final MNavigator navigator;
}

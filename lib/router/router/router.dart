import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/navigation_bar/navigation_bar.dart';
import 'package:muffed/pages/home/home.dart';
import 'package:muffed/pages/inbox/inbox.dart';
import 'package:muffed/pages/profile/profile.dart';
import 'package:muffed/router/router.dart';

part 'router_delegate.dart';

final routerConfig = MRouterConfig();

class MRouterConfig implements RouterConfig<MPage<Object?>> {
  MRouterConfig.configure({
    required this.navigator,
    required this.routerDelegate,
    required this.backButtonDispatcher,
    this.routeInformationParser,
    this.routeInformationProvider,
  });

  factory MRouterConfig() {
    print('create');

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

    return MRouterConfig.configure(
      navigator: navigator,
      routerDelegate: MRouterDelegate(navigator),
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }

  final MNavigator navigator;

  @override
  final RouterDelegate<MPage<Object?>> routerDelegate;

  @override
  final BackButtonDispatcher backButtonDispatcher;

  @override
  final RouteInformationParser<MPage<Object?>>? routeInformationParser;

  @override
  RouteInformationProvider? routeInformationProvider;
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/view/widgets/navigation_bar/navigation_bar.dart';
import 'package:muffed/view/pages/home/home.dart';
import 'package:muffed/view/pages/inbox/inbox.dart';
import 'package:muffed/view/pages/profile/profile.dart';
import 'package:muffed/view/router/router.dart';

part 'root_page.dart';
part 'router_delegate.dart';

final routerConfig = RouterConfig(
  routerDelegate: MRouterDelegate(),
  backButtonDispatcher: RootBackButtonDispatcher(),
);

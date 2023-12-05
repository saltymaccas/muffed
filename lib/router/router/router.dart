import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/navigation_bar/navigation_bar.dart';
import 'package:muffed/pages/home/home.dart';
import 'package:muffed/pages/inbox_page/inbox_page.dart';
import 'package:muffed/pages/profile/profile.dart';
import 'package:muffed/router/router.dart';

part 'router_delegate.dart';

final routerConfig = RouterConfig(
  routerDelegate: MRouterDelegate(),
);

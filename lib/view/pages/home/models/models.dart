import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

class TabViewConfig {
  TabViewConfig({
    required this.key,
    required this.contentType,
    required this.sortType,
  });

  final Key key;
  final HomeContentType contentType;
  final SortType sortType;
}

enum HomeContentType {
  popular,
  subscibed,
  local,
}

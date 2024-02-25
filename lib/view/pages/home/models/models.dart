import 'package:flutter/material.dart';
import 'package:muffed/domain/lemmy/models.dart';
import 'package:muffed/view/pages/home/home.dart';

class TabViewConfig {
  TabViewConfig({
    required this.key,
    required this.contentType,
    required this.sortType,
  });

  final Key key;
  final HomeContentType contentType;
  final LemmySortType sortType;
}

enum HomeContentType {
  popular,
  subscibed,
  local,
}

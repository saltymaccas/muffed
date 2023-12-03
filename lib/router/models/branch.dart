import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:muffed/router/router.dart';

/// Holds a stack of pages and provides methods for manipulating them.
class Branch extends Equatable {
  Branch(this.pages, {GlobalKey<NavigatorState>? key})
      : key = key ?? GlobalKey();

  /// The stack of pages
  final List<MPage> pages;

  final GlobalKey<NavigatorState> key;

  MPage get top => pages.last;

  int get length => pages.length;

  bool get canPop => pages.length > 1;

  Branch pop() {
    if (canPop) pages.removeLast();
    return Branch(pages, key: key);
  }

  Branch push(MPage page) {
    pages.add(page);
    return Branch(pages, key: key);
  }

  @override
  List<Object?> get props => [pages, key];
}

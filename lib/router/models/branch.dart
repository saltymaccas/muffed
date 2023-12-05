import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:muffed/router/router.dart';

/// Holds a stack of pages and provides methods for manipulating them.
class Branch extends Equatable {
  Branch(this.pages, {GlobalKey<NavigatorState>? key})
      : key = key ?? GlobalKey<NavigatorState>();

  /// The stack of pages
  final List<MPage<Object?>> pages;

  final GlobalKey<NavigatorState> key;

  MPage<Object?> get top => pages.last;

  int get length => pages.length;

  bool get canPop => pages.length > 1;

  Branch pop() {
    if (canPop) pages.removeLast();
    return copyWith(pages: pages);
  }

  Branch push(MPage<Object?> page) {
    pages.add(page);
    return copyWith(pages: pages);
  }

  Branch copyWith({
    List<MPage<Object?>>? pages,
    GlobalKey<NavigatorState>? key,
  }) {
    return Branch(
      pages ?? this.pages,
      key: key ?? this.key,
    );
  }

  /// Deep copies the branch
  Branch copy() {
    return Branch(
      List.of(pages),
      key: key,
    );
  }

  @override
  List<Object?> get props => [pages, key];
}

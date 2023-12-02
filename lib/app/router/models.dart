import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../widgets/page.dart';

/// Stores the list of app branches and provides methods for manipulating them.
///
/// Used by MNavigator to store its state.
class MNavigatorState extends Equatable {
  const MNavigatorState(
      {required this.branches, required this.currentBranchIndex});

  /// The branches in the app
  final List<Branch> branches;

  /// The branch the app currently is on
  final int currentBranchIndex;

  Branch get currentBranch => branches[currentBranchIndex];

  GlobalKey<NavigatorState> get currentKey => currentBranch.key;

  MPage<Object?> get currentPage => branches[currentBranchIndex].top;

  bool get canPop => branches[currentBranchIndex].canPop;

  MNavigatorState copyWithDifferentBranch(int newBranch) {
    return MNavigatorState(
      branches: branches,
      currentBranchIndex: newBranch,
    );
  }

  MNavigatorState copyWithPop() {
    final newBranches = branches;
    newBranches[currentBranchIndex] = newBranches[currentBranchIndex].pop();
    return MNavigatorState(
      branches: newBranches,
      currentBranchIndex: currentBranchIndex,
    );
  }

  MNavigatorState copyWithPush(MPage page) {
    final newBranches = branches;
    newBranches[currentBranchIndex] =
        newBranches[currentBranchIndex].push(page);
    return MNavigatorState(
      branches: newBranches,
      currentBranchIndex: currentBranchIndex,
    );
  }

  @override
  List<Object?> get props => [branches, currentBranchIndex];
}

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

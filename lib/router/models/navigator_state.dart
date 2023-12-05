import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:muffed/router/router.dart';

/// Stores the list of app branches and provides methods for manipulating them.
///
/// Used by MNavigator to store its state.
class MNavigatorState extends Equatable {
  const MNavigatorState({
    required this.rootBranch,
    required this.branches,
    required this.currentBranchIndex,
  });

  /// A single branch that goes above every other branch
  final Branch rootBranch;

  /// The branches in the app
  final List<Branch> branches;

  /// The branch the app currently is on
  final int currentBranchIndex;

  Branch get currentBranch => branches[currentBranchIndex];

  GlobalKey<NavigatorState> get currentKey => currentBranch.key;

  MPage<Object?> get currentPage => branches[currentBranchIndex].top;

  bool get canPop => branches[currentBranchIndex].canPop;

  MNavigatorState copyWithRootBranchPush(MPage<Object?> page) => copyWith(
        rootBranch: rootBranch.copy()..push(page),
      );

  MNavigatorState copyWithDifferentBranch(int newBranch) {
    return copyWith(currentBranchIndex: newBranch);
  }

  MNavigatorState copyWithPop() {
    final newBranches = copyBranches();
    newBranches[currentBranchIndex] = newBranches[currentBranchIndex].pop();
    return copyWith(branches: newBranches);
  }

  MNavigatorState copyWithPush(MPage<Object?> page) {
    final newBranches = copyBranches();
    newBranches[currentBranchIndex] =
        newBranches[currentBranchIndex].push(page);
    return copyWith(branches: newBranches);
  }

  /// Deep copies the branches
  List<Branch> copyBranches() =>
      branches.mapIndexed((index, branch) => branch.copy()).toList();

  MNavigatorState copyWith({
    Branch? rootBranch,
    List<Branch>? branches,
    int? currentBranchIndex,
  }) {
    return MNavigatorState(
      rootBranch: rootBranch ?? this.rootBranch,
      branches: branches ?? this.branches,
      currentBranchIndex: currentBranchIndex ?? this.currentBranchIndex,
    );
  }

  @override
  List<Object?> get props => [branches, currentBranchIndex];
}

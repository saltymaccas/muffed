import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:muffed/router/router.dart';

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
    final newBranches = copyBranches();
    newBranches[currentBranchIndex] = newBranches[currentBranchIndex].pop();
    return MNavigatorState(
      branches: newBranches,
      currentBranchIndex: currentBranchIndex,
    );
  }

  MNavigatorState copyWithPush(MPage<Object?> page) {
    final newBranches = copyBranches();
    newBranches[currentBranchIndex] =
        newBranches[currentBranchIndex].push(page);
    return copyWith(branches: newBranches);
  }

  /// Deep copies the branches
  List<Branch> copyBranches() {
    return List.generate(
      branches.length,
      (index) => Branch(
        List.of(branches[index].pages),
        key: branches[index].key,
      ),
    );
  }

  MNavigatorState copyWith({
    List<Branch>? branches,
    int? currentBranchIndex,
  }) {
    return MNavigatorState(
      branches: branches ?? this.branches,
      currentBranchIndex: currentBranchIndex ?? this.currentBranchIndex,
    );
  }

  @override
  List<Object?> get props => [branches, currentBranchIndex];
}

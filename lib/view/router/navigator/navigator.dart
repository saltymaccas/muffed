import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/view/router/router.dart';

/// Provides an interface for manipulating the pages in the branches
class MNavigator extends Cubit<MNavigatorState> {
  MNavigator(super.initialState);

  static MNavigator of(BuildContext context) {
    return BlocProvider.of<MNavigator>(context);
  }

  /// Switches the current branch to the one with the given index
  void switchBranch(int newBranch) {
    emit(state.copyWithDifferentBranch(newBranch));
  }

  /// Removes the top page from the current branch
  bool popPageFromCurrentBranch() {
    if (!state.currentBranch.atRootPage) {
      emit(state.copyWithPop());
      return true;
    } else {
      return false;
    }
  }

  /// Adds a page to the top of the current branch
  void pushPage(Page page) {
    emit(state.copyWithPush(page));
  }

  void pushToRootBranch(MPage<Object?> page) {
    emit(state.copyWithRootBranchPush(page));
  }
}

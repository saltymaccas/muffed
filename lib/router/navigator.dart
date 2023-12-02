import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/widgets/page.dart';

import 'models.dart';

/// Provides an interface for manipulating the pages in the branches
class MNavigator extends Cubit<MNavigatorState> {
  MNavigator(super.initialState);

  void switchBranch(int newBranch) {
    emit(state.changeCurrentBranch(newBranch));
  }

  void pop() {
    emit(state.pop());
  }

  void push(MPage page) {
    emit(state.push(page));
  }
}

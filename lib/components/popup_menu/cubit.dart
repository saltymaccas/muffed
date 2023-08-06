import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MuffedPopupMenuCubit extends Cubit<List<List<Widget>>> {
  MuffedPopupMenuCubit(this.baseItems) : super([baseItems]);

  void addItemSet(List<Widget> items) => emit([...state, items]);

  void removeItemSet() => emit([...state..removeAt(state.length - 1)]);

  final List<Widget> baseItems;
}

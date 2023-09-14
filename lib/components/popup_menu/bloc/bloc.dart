import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

/// The bloc for muffed popup meny button

class MuffedPopupMenuBloc
    extends Bloc<MuffedPopupMenuEvent, MuffedPopupMenuState> {
  ///
  MuffedPopupMenuBloc({required this.initialItems, this.initialSelectedValue})
      : super(MuffedPopupMenuState(
            items: [initialItems], selectedValue: initialSelectedValue ?? 1)) {
    on<ExpandableItemPressed>((event, emit) {
      emit(state.copyWith(items: [...state.items, event.items]));
    });
    on<BackPressed>((event, emit) {
      emit(
        state.copyWith(
          items: [...state.items..removeLast()],
        ),
      );
    });
    on<SelectedValueChanged>((event, emit) {
      emit(state.copyWith(selectedValue: event.value));
    });
  }

  /// The items that will show when the menu is first opened
  List<Widget> initialItems;
  Object? initialSelectedValue;
}

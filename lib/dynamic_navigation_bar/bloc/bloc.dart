import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'event.dart';

part 'state.dart';

class DynamicNavigationBarBloc
    extends Bloc<DynamicNavigationBarEvent, DynamicNavigationBarState> {
  DynamicNavigationBarBloc() : super(DynamicNavigationBarState()) {
    on<GoneToNewMainPage>((event, emit) {
      emit(state.copyWith(selectedItemIndex: event.index));
    });
    on<AddActions>((event, emit) {
      emit(state.copyWith(
          actions: Map.from(state.actions)
            ..[event.itemIndex] = [
              ...state.actions[event.itemIndex]!,
              event.actions
            ]));
    });
    on<RemoveActions>((event, emit) {
      emit(state.copyWith(
          actions: Map.from(state.actions)
            ..[event.itemIndex] = state.actions[event.itemIndex]!
                .sublist(0, state.actions[event.itemIndex]!.length - 1)));
    });
  }
}

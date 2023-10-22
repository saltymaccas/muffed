import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

/// The navigation bar that sits at the bottom of the app
class DynamicNavigationBarBloc
    extends Bloc<DynamicNavigationBarEvent, DynamicNavigationBarState> {
  ///
  DynamicNavigationBarBloc() : super(DynamicNavigationBarState()) {
    on<GoneToNewMainPage>((event, emit) {
      emit(state.copyWith(selectedItemIndex: event.index));
    });
    on<PageAdded>((event, emit) {
      emit(
        state.copyWith(
          actions: Map.from(state.pageStackInfo)
            ..[event.itemIndex] = [
              ...state.pageStackInfo[event.itemIndex]!,
              event.pageInfo,
            ],
        ),
      );
    });
    on<PageRemoved>((event, emit) {
      emit(state.copyWith(
          actions: Map.from(state.pageStackInfo)
            ..[event.itemIndex] = state.pageStackInfo[event.itemIndex]!
                .sublist(0, state.pageStackInfo[event.itemIndex]!.length - 1)));
    });
  }
}

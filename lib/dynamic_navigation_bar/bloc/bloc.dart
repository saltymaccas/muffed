import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'event.dart';

part 'state.dart';

class DynamicNavigationBarBloc
    extends Bloc<DynamicNavigationBarEvent, DynamicNavigationBarState> {
  DynamicNavigationBarBloc()
      : super(DynamicNavigationBarState(selectedItemIndex: 0)) {
    on<GoneToNewMainPage>((event, emit) {
      emit(DynamicNavigationBarState(selectedItemIndex: event.index));

      print(event.index);
    });
  }
}

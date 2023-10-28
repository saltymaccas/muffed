import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

const Duration _animDur = Duration(milliseconds: 500);
const int _animInterval = 200;
const Curve _animCurve = Curves.easeInOutCubic;

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
      emit(
        state.copyWith(
          actions: Map.from(state.pageStackInfo)
            ..[event.itemIndex] = state.pageStackInfo[event.itemIndex]!
                .sublist(0, state.pageStackInfo[event.itemIndex]!.length - 1),
        ),
      );
    });
    on<EditPageActions>((event, emit) {
      final List<Widget> animatedActions = [];

      for (var i = 0; i < event.actions.length; i++) {
        final Widget action = event.actions[i];
        animatedActions.add(
          action
              .animate(autoPlay: true)
              .slideY(
                duration: _animDur,
                curve: _animCurve,
                begin: 3,
                delay: Duration(milliseconds: _animInterval * i),
                end: 0,
              )
              .fadeIn(
                duration: _animDur,
                begin: 0,
                curve: _animCurve,
                delay: Duration(milliseconds: _animInterval * i),
              ),
        );
      }

      emit(
        state.copyWith(
          actions: Map.from(state.pageStackInfo)
            ..[event.itemIndex] = [
              ...state.pageStackInfo[event.itemIndex]!,
              PageInfo(context: event.context, actions: animatedActions),
            ],
        ),
      );
    });
  }
}

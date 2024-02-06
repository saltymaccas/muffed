import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

part 'event.dart';

part 'state.dart';

final _log = Logger('DynamicNavigationBarBloc');

const Duration _animDur = Duration(milliseconds: 500);
const int _animInterval = 200;
const Curve _animCurve = Curves.easeInOutCubic;

/// The navigation bar that sits at the bottom of the app
class DynamicNavigationBarBloc
    extends Bloc<DynamicNavigationBarEvent, DynamicNavigationBarState> {
  ///
  DynamicNavigationBarBloc() : super(const DynamicNavigationBarState()) {
    on<GoneToNewMainPage>((event, emit) {
      emit(state.copyWith(selectedItemIndex: event.index));
    });
    on<PageAdded>((event, emit) {
      emit(
        state.copyWith(
          pageStackInfo: Map.from(state.pageStackInfo)
            ..[event.page.index] = [
              ...state.pageStackInfo[event.page.index]!,
              event.pageInfo,
            ],
        ),
      );
    });
    on<PageRemoved>((event, emit) {
      emit(
        state.copyWith(
          pageStackInfo: Map.from(state.pageStackInfo)
            ..[event.page.index] = state.pageStackInfo[event.page.index]!
                .sublist(0, state.pageStackInfo[event.page.index]!.length - 1),
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

      final indexToEdit = state.pageStackInfo[event.page.index]!.indexWhere(
            (element) => element.id == event.id,
      );

      /// deep copy page stack info
      final copyOfPageInfoMap = {
        for (int i = 0; i < state.pageStackInfo.length; i++)
          i: [...state.pageStackInfo[i]!],
      };

      copyOfPageInfoMap[event.page.index]![indexToEdit] = PageInfo(
        context: event.context,
        actions: animatedActions,
        id: event.id,
      );


      emit(
        state.copyWith(
          pageStackInfo: copyOfPageInfoMap,
        ),
      );
    });
  }

  @override
  void onChange(Change<DynamicNavigationBarState> change) {
    super.onChange(change);
    _log.fine(change);
  }

  @override
  void onTransition(Transition<DynamicNavigationBarEvent,
      DynamicNavigationBarState> transition,) {
    super.onTransition(transition);
    _log.fine(transition);
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/repo/lemmy/models/models.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('GlobalBloc');

/// The bloc that controls the global app state
class GlobalBloc extends HydratedBloc<GlobalEvent, GlobalState> {
  ///
  GlobalBloc() : super(const GlobalState()) {
    on<AccountLoggedIn>((event, emit) {
      emit(
        state.copyWith(
          lemmyAccounts: [...state.lemmyAccounts, event.account],
          lemmySelectedAccount: state.lemmyAccounts.length,
        ),
      );
    });
    on<AccountSwitched>((event, emit) {
      emit(state.copyWith(lemmySelectedAccount: event.accountIndex));
    });
    on<AccountRemoved>((event, emit) {
      emit(
        state.copyWith(
          lemmySelectedAccount: -1,
          lemmyAccounts: state.lemmyAccounts..removeAt(event.index),
        ),
      );
    });
    on<SettingChanged>((event, emit) {
      emit(event.newState);
    });
  }

  LemmyAccountData? getSelectedLemmyAccount() =>
      state.getSelectedLemmyAccount();

  @override
  void onChange(Change<GlobalState> change) {
    super.onChange(change);
    _log.fine(change);
  }

  @override
  void onTransition(Transition<GlobalEvent, GlobalState> transition) {
    super.onTransition(transition);
    _log.fine(transition);
  }

  @override
  GlobalState fromJson(Map<String, dynamic> json) => GlobalState.fromMap(json);

  @override
  Map<String, dynamic> toJson(GlobalState state) => state.toMap();
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'state.dart';

part 'event.dart';

/// The bloc that controls the global app state
class GlobalBloc extends HydratedBloc<GlobalEvent, GlobalState> {
  ///
  GlobalBloc() : super(GlobalState()) {
    on<AccountLoggedIn>((event, emit) {
      emit(
        state.copyWith(
          lemmyAccounts: [...state.lemmyAccounts, event.account],
          lemmySelectedAccount: state.lemmyAccounts.length,
        ),
      );
    });
    on<UserRequestsLemmyAccountSwitch>((event, emit) {
      emit(state.copyWith(lemmySelectedAccount: event.accountIndex));
    });
    on<UserRequestsAccountRemoval>((event, emit) {
      emit(
        state.copyWith(
          lemmySelectedAccount: -1,
          lemmyAccounts: state.lemmyAccounts..removeAt(event.index),
        ),
      );
    });
    on<ThemeModeChanged>((event, emit) {
      emit(
        state.copyWith(
          themeMode: event.themeMode,
        ),
      );
    });
    on<UseDynamicColorSchemeChanged>((event, emit) {
      emit(
        state.copyWith(
          useDynamicColorScheme: event.useDynamicColorScheme,
        ),
      );
    });
    on<SeedColorChanged>((event, emit) {
      emit(state.copyWith(seedColor: event.seedColor));
    });
  }

  LemmyAccountData? getSelectedLemmyAccount() {
    return (state.lemmySelectedAccount == -1)
        ? null
        : state.lemmyAccounts[state.lemmySelectedAccount];
  }

  String getLemmyBaseUrl() {
    return (state.lemmySelectedAccount == -1)
        ? state.lemmyDefaultHomeServer
        : state.lemmyAccounts[state.lemmySelectedAccount].homeServer;
  }

  @override
  GlobalState fromJson(Map<String, dynamic> json) => GlobalState.fromMap(json);

  @override
  Map<String, dynamic> toJson(GlobalState state) => state.toMap();
}

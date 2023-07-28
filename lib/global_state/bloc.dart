import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'state.dart';

part 'event.dart';

/// The bloc that controls the global app state
class GlobalBloc extends HydratedBloc<GlobalEvent, GlobalState> {
  ///
  GlobalBloc() : super(GlobalState()) {
    on<AccountLoggedIn>((event, emit) {
      emit(state.copyWith(
          lemmyAccounts: [...state.lemmyAccounts, event.account],
          lemmySelectedAccount: state.lemmyAccounts.length));
    });
    on<UserRequestsLemmyAccountSwitch>((event, emit) {
      emit(state.copyWith(lemmySelectedAccount: event.accountIndex));
    });
    on<UserRequestsAccountRemoval>((event, emit) {
      emit(
        state.copyWith(
          lemmySelectedAccount: null,
          lemmyAccounts: state.lemmyAccounts..removeAt(event.index),
        ),
      );
    });
  }

  LemmyAccountData? getSelectedLemmyAccount() {
    return (state.lemmySelectedAccount == null)
        ? null
        : state.lemmyAccounts[state.lemmySelectedAccount!];
  }

  String getLemmyBaseUrl() {
    return (state.lemmySelectedAccount == null)
        ? state.lemmyDefaultHomeServer
        : state.lemmyAccounts[state.lemmySelectedAccount!].homeServer;
  }

  @override
  GlobalState fromJson(Map<String, dynamic> json) => GlobalState.fromMap(json);

  @override
  Map<String, dynamic> toJson(GlobalState state) => state.toMap();
}

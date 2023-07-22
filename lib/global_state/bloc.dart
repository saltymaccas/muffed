import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'state.dart';

part 'event.dart';

class GlobalBloc extends HydratedBloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(GlobalState()) {
    on<AccountLoggedIn>((event, emit) {
      emit(state.copyWith(
          lemmyAccounts: [...state.lemmyAccounts, event.account],
          lemmySelectedAccount: state.lemmyAccounts.length));
    });
    on<UserRequestsLemmyAccountSwitch>((event, emit) {
      emit(state.copyWith(lemmySelectedAccount: event.accountIndex));
    });
  }

  LemmyAccountData? getSelectedLemmyAccount() {
    return (state.lemmySelectedAccount == null)
        ? null
        : state.lemmyAccounts[state.lemmySelectedAccount!];
  }

  @override
  GlobalState fromJson(Map<String, dynamic> json) => GlobalState.fromMap(json);

  @override
  Map<String, dynamic> toJson(GlobalState state) => state.toMap();
}

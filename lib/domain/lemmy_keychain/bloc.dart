import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lemmy_api_client/v3.dart';

part 'bloc.freezed.dart';
part 'bloc.g.dart';
part 'event.dart';
part 'state.dart';

class LemmyKeychainBloc
    extends HydratedBloc<LemmyKeychainEvent, LemmyKeychainState> {
  LemmyKeychainBloc()
      : super(
          const LemmyKeychainState(
            keys: [LemmyKey(instanceAddress: 'https://sh.itjust.works')],
            activeKey: LemmyKey(instanceAddress: 'https://sh.itjust.works'),
          ),
        ) {
    on<KeyAdded>(_onKeyAdded);
    on<ActiveKeyChanged>(_onActiveKeyChanged);
    on<KeyRemoved>(_onKeyRemoved);
  }

  void _onKeyRemoved(KeyRemoved event, Emitter<LemmyKeychainState> emit) {
    // dont delete if last key
    if (state.keys.length == 1) {
      return;
    }

    final jwt = state.keys[event.index].authToken;
    final addr = state.keys[event.index].instanceAddress;
    final l = List<LemmyKey>.from(state.keys)..removeAt(event.index);
    emit(
      state.copyWith(
        keys: l,
      ),
    );
  }

  Future<void> _onKeyAdded(
    KeyAdded event,
    Emitter<LemmyKeychainState> emit,
  ) async {
    final i = state.keys.length;
    emit(state.copyWith(keys: [...state.keys, event.key]));

    final lem = LemmyApiV3(event.key.instanceAddress);

    final site = await lem.run(const GetSite());

    final k = state.keys[i];
    final l = List<LemmyKey>.from(state.keys);
    l[i] = k.copyWith(site: site);
    emit(state.copyWith(keys: l));
  }

  void _onActiveKeyChanged(
    ActiveKeyChanged event,
    Emitter<LemmyKeychainState> emit,
  ) {
    emit(state.copyWith(activeKey: event.key));
  }

  @override
  LemmyKeychainState fromJson(Map<String, Object?> json) =>
      LemmyKeychainState.fromJson(json);

  @override
  Map<String, Object?> toJson(LemmyKeychainState state) => state.toJson();
}

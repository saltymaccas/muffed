import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lemmy_api_client/v3.dart';

import 'dart:async';

part 'state.dart';
part 'event.dart';
part 'bloc.freezed.dart';
part 'bloc.g.dart';

class LemmyKeychainBloc
    extends HydratedBloc<LemmyKeychainEvent, LemmyKeychainState> {
  LemmyKeychainBloc()
      : super(
          const LemmyKeychainState(
            keys: [LemmyKey(instanceAddress: 'https://sh.itjust.works')],
            activeKeyIndex: 0,
          ),
        ) {
    on<KeyAdded>(_onKeyAdded);
    on<ActiveKeyChanged>(_onActiveKeyChanged);
  }

  void _onKeyAdded(KeyAdded event, Emitter<LemmyKeychainState> emit) {
    emit(state.copyWith(keys: [...state.keys, event.key]));
  }

  void _onActiveKeyChanged(
      ActiveKeyChanged event, Emitter<LemmyKeychainState> emit) {
    emit(state.copyWith(activeKeyIndex: event.index));
  }

  @override
  LemmyKeychainState fromJson(Map<String, Object?> json) =>
      LemmyKeychainState.fromJson(json);

  @override
  Map<String, Object?> toJson(LemmyKeychainState state) => state.toJson();
}

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'bloc.freezed.dart';
part 'bloc.g.dart';
part 'event.dart';
part 'state.dart';

class LocalOptionsBloc
    extends HydratedBloc<LocalOptionsEvent, LocalOptionsState> {
  LocalOptionsBloc()
      : super(
          const LocalOptionsState(
            themeMode: ThemeMode.system,
            seedColor: Colors.blue,
            useSystemSeedColor: true,
          ),
        ) {
    on<ThemeModeChanged>(_onThemeModeChanged);
    on<ColorSchemeChanged>(_onColorSchemeChanged);
  }

  void _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<LocalOptionsState> emit,
  ) {
    emit(state.copyWith(themeMode: event.themeMode));
  }

  void _onColorSchemeChanged(
    ColorSchemeChanged event,
    Emitter<LocalOptionsState> emit,
  ) {
    emit(
      state.copyWith(
        useSystemSeedColor: event.useSystemColorScheme,
        seedColor: event.seedColorScheme,
      ),
    );
  }

  @override
  LocalOptionsState fromJson(Map<String, Object?> json) =>
      LocalOptionsState.fromJson(json);

  @override
  Map<String, Object?> toJson(LocalOptionsState state) => state.toJson();
}

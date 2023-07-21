import 'dart:js/js_wasm.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'state.dart';

part 'event.dart';

class GlobalBloc extends HydratedBloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(GlobalState()) {}

  @override
  GlobalState fromJson(Map<String, dynamic> json) => GlobalState.fromMap(json);

  @override
  Map<String, dynamic> toJson(GlobalState state) => state.toMap();
}

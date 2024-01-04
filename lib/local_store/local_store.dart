import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/models/url.dart';
import 'package:muffed/repo/lemmy/models/models.dart';

part 'models.dart';
part 'models.g.dart';

final _log = Logger('GlobalBloc');

/// The bloc that controls the global app state
class LocalStore extends HydratedCubit<GlobalState> {
  LocalStore() : super(const GlobalState());

  static LocalStore of(BuildContext context) =>
      BlocProvider.of<LocalStore>(context);

  @override
  GlobalState fromJson(Map<String, dynamic> json) => GlobalState.fromMap(json);

  @override
  Map<String, dynamic> toJson(GlobalState state) => state.toMap();
}

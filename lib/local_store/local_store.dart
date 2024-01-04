import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/models/url.dart';
import 'package:muffed/repo/lemmy/models/models.dart';

part 'models/models.dart';
part 'models.g.dart';

final _log = Logger('GlobalBloc');

/// The bloc that controls the global app state
class LocalStore extends HydratedCubit<LocalStoreModel> {
  LocalStore() : super(const LocalStoreModel());

  static LocalStore of(BuildContext context) =>
      BlocProvider.of<LocalStore>(context);

  @override
  LocalStoreModel fromJson(Map<String, dynamic> json) =>
      LocalStoreModel.fromMap(json);

  @override
  Map<String, dynamic> toJson(LocalStoreModel state) => state.toMap();
}

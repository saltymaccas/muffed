import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:muffed/db/models/app_look.dart';
import 'package:muffed/db/models/auth.dart';

part 'db_model.dart';
part 'db.g.dart';

final _log = Logger('GlobalBloc');

/// The bloc that controls the global app state
class DB extends HydratedCubit<DBModel> {
  DB() : super(const DBModel());

  static DB of(BuildContext context) => BlocProvider.of<DB>(context);

  @override
  DBModel fromJson(Map<String, dynamic> json) => DBModel.fromMap(json);

  @override
  Map<String, dynamic> toJson(DBModel state) => state.toMap();
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DBModel _$DBModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'DBModel',
      json,
      ($checkedConvert) {
        final val = DBModel(
          auth: $checkedConvert(
              'auth',
              (v) => v == null
                  ? const AuthRepository(
                      lemmy: LemmyAuthRepository(keys: [
                      LemmyAnonAuthKey(
                          url: 'sh.itjust.works', name: 'Anonymous', id: 0)
                    ], activeKeyIndex: 0))
                  : AuthRepository.fromJson(v as Map<String, dynamic>)),
          look: $checkedConvert(
              'look',
              (v) => v == null
                  ? const ThemeConfig(
                      bodyTextScaleFactor: 1,
                      labelTextScaleFactor: 1,
                      titleTextScaleFactor: 1,
                      colorSchemeMode: ThemeMode.system,
                      seedColor: Colors.greenAccent,
                      wallBasedColorScheme: true)
                  : ThemeConfig.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$DBModelToJson(DBModel instance) => <String, dynamic>{
      'auth': instance.auth.toJson(),
      'look': instance.look.toJson(),
    };

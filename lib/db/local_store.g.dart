// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DBModel _$DBModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'DBModel',
      json,
      ($checkedConvert) {
        final val = DBModel(
          authRepository: $checkedConvert(
              'auth_repository',
              (v) => v == null
                  ? const AuthRepository(
                      currentLemmyAuthKey: 0,
                      lemmyAuthKeys: [
                          LemmyAnonAuthKey(
                              url: 'sh.itjust.works', name: "Anonymous", id: 0)
                        ])
                  : AuthRepository.fromJson(v as Map<String, dynamic>)),
          appLook: $checkedConvert(
              'app_look',
              (v) => v == null
                  ? const AppLookModel(
                      bodyTextScaleFactor: 1,
                      labelTextScaleFactor: 1,
                      titleTextScaleFactor: 1,
                      colorSchemeMode: ThemeMode.system,
                      seedColor: Colors.greenAccent,
                      wallBasedColorScheme: true)
                  : AppLookModel.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'authRepository': 'auth_repository',
        'appLook': 'app_look'
      },
    );

Map<String, dynamic> _$DBModelToJson(DBModel instance) => <String, dynamic>{
      'auth_repository': instance.authRepository.toJson(),
      'app_look': instance.appLook.toJson(),
    };

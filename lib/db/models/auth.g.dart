// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRepository _$AuthRepositoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AuthRepository',
      json,
      ($checkedConvert) {
        final val = AuthRepository(
          lemmyAuthKeys: $checkedConvert(
              'lemmy_auth_keys',
              (v) => (v as List<dynamic>)
                  .map((e) => LemmyAuthKey.fromJson(e as Map<String, dynamic>))
                  .toList()),
          currentLemmyAuthKey:
              $checkedConvert('current_lemmy_auth_key', (v) => v as int),
        );
        return val;
      },
      fieldKeyMap: const {
        'lemmyAuthKeys': 'lemmy_auth_keys',
        'currentLemmyAuthKey': 'current_lemmy_auth_key'
      },
    );

Map<String, dynamic> _$AuthRepositoryToJson(AuthRepository instance) =>
    <String, dynamic>{
      'lemmy_auth_keys': instance.lemmyAuthKeys.map((e) => e.toJson()).toList(),
      'current_lemmy_auth_key': instance.currentLemmyAuthKey,
    };

LemmyAuthKey _$LemmyAuthKeyFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LemmyAuthKey',
      json,
      ($checkedConvert) {
        final val = LemmyAuthKey(
          url: $checkedConvert('url', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$LemmyAuthKeyToJson(LemmyAuthKey instance) =>
    <String, dynamic>{
      'url': instance.url,
    };

LemmyAnonAuthKey _$LemmyAnonAuthKeyFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LemmyAnonAuthKey',
      json,
      ($checkedConvert) {
        final val = LemmyAnonAuthKey(
          url: $checkedConvert('url', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          id: $checkedConvert('id', (v) => v as int),
        );
        return val;
      },
    );

Map<String, dynamic> _$LemmyAnonAuthKeyToJson(LemmyAnonAuthKey instance) =>
    <String, dynamic>{
      'url': instance.url,
      'name': instance.name,
      'id': instance.id,
    };

LemmyUserAuthKey _$LemmyUserAuthKeyFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LemmyUserAuthKey',
      json,
      ($checkedConvert) {
        final val = LemmyUserAuthKey(
          url: $checkedConvert('url', (v) => v as String),
          jwt: $checkedConvert('jwt', (v) => v as String),
          userInfo: $checkedConvert(
              'user_info',
              (v) => v == null
                  ? null
                  : LemmyUserAuthInfo.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'userInfo': 'user_info'},
    );

Map<String, dynamic> _$LemmyUserAuthKeyToJson(LemmyUserAuthKey instance) =>
    <String, dynamic>{
      'url': instance.url,
      'jwt': instance.jwt,
      'user_info': instance.userInfo?.toJson(),
    };

LemmyUserAuthInfo _$LemmyUserAuthInfoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LemmyUserAuthInfo',
      json,
      ($checkedConvert) {
        final val = LemmyUserAuthInfo(
          name: $checkedConvert('name', (v) => v as String),
          id: $checkedConvert('id', (v) => v as int),
          displayName: $checkedConvert('display_name', (v) => v as String?),
          avatar: $checkedConvert('avatar', (v) => v as String?),
          banner: $checkedConvert('banner', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'displayName': 'display_name'},
    );

Map<String, dynamic> _$LemmyUserAuthInfoToJson(LemmyUserAuthInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'display_name': instance.displayName,
      'avatar': instance.avatar,
      'banner': instance.banner,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LemmyKeychainStateImpl _$$LemmyKeychainStateImplFromJson(
        Map<String, dynamic> json) =>
    _$LemmyKeychainStateImpl(
      activeKeyIndex: json['activeKeyIndex'] as int,
      keys: (json['keys'] as List<dynamic>)
          .map((e) => LemmyKey.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LemmyKeychainStateImplToJson(
        _$LemmyKeychainStateImpl instance) =>
    <String, dynamic>{
      'activeKeyIndex': instance.activeKeyIndex,
      'keys': instance.keys,
    };

_$LemmyKeyImpl _$$LemmyKeyImplFromJson(Map<String, dynamic> json) =>
    _$LemmyKeyImpl(
      instanceAddress: json['instanceAddress'] as String,
      authToken: json['authToken'] as String?,
    );

Map<String, dynamic> _$$LemmyKeyImplToJson(_$LemmyKeyImpl instance) =>
    <String, dynamic>{
      'instanceAddress': instance.instanceAddress,
      'authToken': instance.authToken,
    };

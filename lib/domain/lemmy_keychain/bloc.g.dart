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
      site: _$JsonConverterFromJson<Map<String, Object?>, GetSiteResponse>(
          json['site'], const _GetSiteResponseConverter().fromJson),
    );

Map<String, dynamic> _$$LemmyKeyImplToJson(_$LemmyKeyImpl instance) =>
    <String, dynamic>{
      'instanceAddress': instance.instanceAddress,
      'authToken': instance.authToken,
      'site': _$JsonConverterToJson<Map<String, Object?>, GetSiteResponse>(
          instance.site, const _GetSiteResponseConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

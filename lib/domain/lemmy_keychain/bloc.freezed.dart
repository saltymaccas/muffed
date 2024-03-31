// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LemmyKeychainState _$LemmyKeychainStateFromJson(Map<String, dynamic> json) {
  return _LemmyKeychainState.fromJson(json);
}

/// @nodoc
mixin _$LemmyKeychainState {
  int get activeKeyIndex => throw _privateConstructorUsedError;
  List<LemmyKey> get keys => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LemmyKeychainStateCopyWith<LemmyKeychainState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LemmyKeychainStateCopyWith<$Res> {
  factory $LemmyKeychainStateCopyWith(
          LemmyKeychainState value, $Res Function(LemmyKeychainState) then) =
      _$LemmyKeychainStateCopyWithImpl<$Res, LemmyKeychainState>;
  @useResult
  $Res call({int activeKeyIndex, List<LemmyKey> keys});
}

/// @nodoc
class _$LemmyKeychainStateCopyWithImpl<$Res, $Val extends LemmyKeychainState>
    implements $LemmyKeychainStateCopyWith<$Res> {
  _$LemmyKeychainStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeKeyIndex = null,
    Object? keys = null,
  }) {
    return _then(_value.copyWith(
      activeKeyIndex: null == activeKeyIndex
          ? _value.activeKeyIndex
          : activeKeyIndex // ignore: cast_nullable_to_non_nullable
              as int,
      keys: null == keys
          ? _value.keys
          : keys // ignore: cast_nullable_to_non_nullable
              as List<LemmyKey>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LemmyKeychainStateImplCopyWith<$Res>
    implements $LemmyKeychainStateCopyWith<$Res> {
  factory _$$LemmyKeychainStateImplCopyWith(_$LemmyKeychainStateImpl value,
          $Res Function(_$LemmyKeychainStateImpl) then) =
      __$$LemmyKeychainStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int activeKeyIndex, List<LemmyKey> keys});
}

/// @nodoc
class __$$LemmyKeychainStateImplCopyWithImpl<$Res>
    extends _$LemmyKeychainStateCopyWithImpl<$Res, _$LemmyKeychainStateImpl>
    implements _$$LemmyKeychainStateImplCopyWith<$Res> {
  __$$LemmyKeychainStateImplCopyWithImpl(_$LemmyKeychainStateImpl _value,
      $Res Function(_$LemmyKeychainStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeKeyIndex = null,
    Object? keys = null,
  }) {
    return _then(_$LemmyKeychainStateImpl(
      activeKeyIndex: null == activeKeyIndex
          ? _value.activeKeyIndex
          : activeKeyIndex // ignore: cast_nullable_to_non_nullable
              as int,
      keys: null == keys
          ? _value._keys
          : keys // ignore: cast_nullable_to_non_nullable
              as List<LemmyKey>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LemmyKeychainStateImpl extends _LemmyKeychainState {
  const _$LemmyKeychainStateImpl(
      {required this.activeKeyIndex, required final List<LemmyKey> keys})
      : _keys = keys,
        super._();

  factory _$LemmyKeychainStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$LemmyKeychainStateImplFromJson(json);

  @override
  final int activeKeyIndex;
  final List<LemmyKey> _keys;
  @override
  List<LemmyKey> get keys {
    if (_keys is EqualUnmodifiableListView) return _keys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keys);
  }

  @override
  String toString() {
    return 'LemmyKeychainState(activeKeyIndex: $activeKeyIndex, keys: $keys)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LemmyKeychainStateImpl &&
            (identical(other.activeKeyIndex, activeKeyIndex) ||
                other.activeKeyIndex == activeKeyIndex) &&
            const DeepCollectionEquality().equals(other._keys, _keys));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, activeKeyIndex, const DeepCollectionEquality().hash(_keys));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LemmyKeychainStateImplCopyWith<_$LemmyKeychainStateImpl> get copyWith =>
      __$$LemmyKeychainStateImplCopyWithImpl<_$LemmyKeychainStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LemmyKeychainStateImplToJson(
      this,
    );
  }
}

abstract class _LemmyKeychainState extends LemmyKeychainState {
  const factory _LemmyKeychainState(
      {required final int activeKeyIndex,
      required final List<LemmyKey> keys}) = _$LemmyKeychainStateImpl;
  const _LemmyKeychainState._() : super._();

  factory _LemmyKeychainState.fromJson(Map<String, dynamic> json) =
      _$LemmyKeychainStateImpl.fromJson;

  @override
  int get activeKeyIndex;
  @override
  List<LemmyKey> get keys;
  @override
  @JsonKey(ignore: true)
  _$$LemmyKeychainStateImplCopyWith<_$LemmyKeychainStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LemmyKey _$LemmyKeyFromJson(Map<String, dynamic> json) {
  return _LemmyKey.fromJson(json);
}

/// @nodoc
mixin _$LemmyKey {
  String get instanceAddress => throw _privateConstructorUsedError;
  String? get authToken => throw _privateConstructorUsedError;
  @_GetSiteResponseConverter()
  GetSiteResponse? get site => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LemmyKeyCopyWith<LemmyKey> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LemmyKeyCopyWith<$Res> {
  factory $LemmyKeyCopyWith(LemmyKey value, $Res Function(LemmyKey) then) =
      _$LemmyKeyCopyWithImpl<$Res, LemmyKey>;
  @useResult
  $Res call(
      {String instanceAddress,
      String? authToken,
      @_GetSiteResponseConverter() GetSiteResponse? site});

  $GetSiteResponseCopyWith<$Res>? get site;
}

/// @nodoc
class _$LemmyKeyCopyWithImpl<$Res, $Val extends LemmyKey>
    implements $LemmyKeyCopyWith<$Res> {
  _$LemmyKeyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instanceAddress = null,
    Object? authToken = freezed,
    Object? site = freezed,
  }) {
    return _then(_value.copyWith(
      instanceAddress: null == instanceAddress
          ? _value.instanceAddress
          : instanceAddress // ignore: cast_nullable_to_non_nullable
              as String,
      authToken: freezed == authToken
          ? _value.authToken
          : authToken // ignore: cast_nullable_to_non_nullable
              as String?,
      site: freezed == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as GetSiteResponse?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GetSiteResponseCopyWith<$Res>? get site {
    if (_value.site == null) {
      return null;
    }

    return $GetSiteResponseCopyWith<$Res>(_value.site!, (value) {
      return _then(_value.copyWith(site: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LemmyKeyImplCopyWith<$Res>
    implements $LemmyKeyCopyWith<$Res> {
  factory _$$LemmyKeyImplCopyWith(
          _$LemmyKeyImpl value, $Res Function(_$LemmyKeyImpl) then) =
      __$$LemmyKeyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String instanceAddress,
      String? authToken,
      @_GetSiteResponseConverter() GetSiteResponse? site});

  @override
  $GetSiteResponseCopyWith<$Res>? get site;
}

/// @nodoc
class __$$LemmyKeyImplCopyWithImpl<$Res>
    extends _$LemmyKeyCopyWithImpl<$Res, _$LemmyKeyImpl>
    implements _$$LemmyKeyImplCopyWith<$Res> {
  __$$LemmyKeyImplCopyWithImpl(
      _$LemmyKeyImpl _value, $Res Function(_$LemmyKeyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instanceAddress = null,
    Object? authToken = freezed,
    Object? site = freezed,
  }) {
    return _then(_$LemmyKeyImpl(
      instanceAddress: null == instanceAddress
          ? _value.instanceAddress
          : instanceAddress // ignore: cast_nullable_to_non_nullable
              as String,
      authToken: freezed == authToken
          ? _value.authToken
          : authToken // ignore: cast_nullable_to_non_nullable
              as String?,
      site: freezed == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as GetSiteResponse?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LemmyKeyImpl implements _LemmyKey {
  const _$LemmyKeyImpl(
      {required this.instanceAddress,
      this.authToken,
      @_GetSiteResponseConverter() this.site});

  factory _$LemmyKeyImpl.fromJson(Map<String, dynamic> json) =>
      _$$LemmyKeyImplFromJson(json);

  @override
  final String instanceAddress;
  @override
  final String? authToken;
  @override
  @_GetSiteResponseConverter()
  final GetSiteResponse? site;

  @override
  String toString() {
    return 'LemmyKey(instanceAddress: $instanceAddress, authToken: $authToken, site: $site)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LemmyKeyImpl &&
            (identical(other.instanceAddress, instanceAddress) ||
                other.instanceAddress == instanceAddress) &&
            (identical(other.authToken, authToken) ||
                other.authToken == authToken) &&
            (identical(other.site, site) || other.site == site));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, instanceAddress, authToken, site);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LemmyKeyImplCopyWith<_$LemmyKeyImpl> get copyWith =>
      __$$LemmyKeyImplCopyWithImpl<_$LemmyKeyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LemmyKeyImplToJson(
      this,
    );
  }
}

abstract class _LemmyKey implements LemmyKey {
  const factory _LemmyKey(
          {required final String instanceAddress,
          final String? authToken,
          @_GetSiteResponseConverter() final GetSiteResponse? site}) =
      _$LemmyKeyImpl;

  factory _LemmyKey.fromJson(Map<String, dynamic> json) =
      _$LemmyKeyImpl.fromJson;

  @override
  String get instanceAddress;
  @override
  String? get authToken;
  @override
  @_GetSiteResponseConverter()
  GetSiteResponse? get site;
  @override
  @JsonKey(ignore: true)
  _$$LemmyKeyImplCopyWith<_$LemmyKeyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

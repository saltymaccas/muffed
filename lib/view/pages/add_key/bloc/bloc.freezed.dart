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

/// @nodoc
mixin _$AddKeyState {
  AddKeyStatus get status => throw _privateConstructorUsedError;
  GetSiteMetadataResponse? get site => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AddKeyStateCopyWith<AddKeyState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddKeyStateCopyWith<$Res> {
  factory $AddKeyStateCopyWith(
          AddKeyState value, $Res Function(AddKeyState) then) =
      _$AddKeyStateCopyWithImpl<$Res, AddKeyState>;
  @useResult
  $Res call(
      {AddKeyStatus status,
      GetSiteMetadataResponse? site,
      String? errorMessage});

  $GetSiteMetadataResponseCopyWith<$Res>? get site;
}

/// @nodoc
class _$AddKeyStateCopyWithImpl<$Res, $Val extends AddKeyState>
    implements $AddKeyStateCopyWith<$Res> {
  _$AddKeyStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? site = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AddKeyStatus,
      site: freezed == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as GetSiteMetadataResponse?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GetSiteMetadataResponseCopyWith<$Res>? get site {
    if (_value.site == null) {
      return null;
    }

    return $GetSiteMetadataResponseCopyWith<$Res>(_value.site!, (value) {
      return _then(_value.copyWith(site: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AddKeyStateImplCopyWith<$Res>
    implements $AddKeyStateCopyWith<$Res> {
  factory _$$AddKeyStateImplCopyWith(
          _$AddKeyStateImpl value, $Res Function(_$AddKeyStateImpl) then) =
      __$$AddKeyStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AddKeyStatus status,
      GetSiteMetadataResponse? site,
      String? errorMessage});

  @override
  $GetSiteMetadataResponseCopyWith<$Res>? get site;
}

/// @nodoc
class __$$AddKeyStateImplCopyWithImpl<$Res>
    extends _$AddKeyStateCopyWithImpl<$Res, _$AddKeyStateImpl>
    implements _$$AddKeyStateImplCopyWith<$Res> {
  __$$AddKeyStateImplCopyWithImpl(
      _$AddKeyStateImpl _value, $Res Function(_$AddKeyStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? site = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$AddKeyStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AddKeyStatus,
      site: freezed == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as GetSiteMetadataResponse?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AddKeyStateImpl implements _AddKeyState {
  const _$AddKeyStateImpl({required this.status, this.site, this.errorMessage});

  @override
  final AddKeyStatus status;
  @override
  final GetSiteMetadataResponse? site;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'AddKeyState(status: $status, site: $site, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddKeyStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.site, site) || other.site == site) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, site, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddKeyStateImplCopyWith<_$AddKeyStateImpl> get copyWith =>
      __$$AddKeyStateImplCopyWithImpl<_$AddKeyStateImpl>(this, _$identity);
}

abstract class _AddKeyState implements AddKeyState {
  const factory _AddKeyState(
      {required final AddKeyStatus status,
      final GetSiteMetadataResponse? site,
      final String? errorMessage}) = _$AddKeyStateImpl;

  @override
  AddKeyStatus get status;
  @override
  GetSiteMetadataResponse? get site;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$AddKeyStateImplCopyWith<_$AddKeyStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

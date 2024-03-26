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

LocalOptionsState _$LocalOptionsStateFromJson(Map<String, dynamic> json) {
  return _LocalOptionsState.fromJson(json);
}

/// @nodoc
mixin _$LocalOptionsState {
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  @ColorConverter()
  Color get seedColor => throw _privateConstructorUsedError;
  bool get useSystemSeedColor => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocalOptionsStateCopyWith<LocalOptionsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalOptionsStateCopyWith<$Res> {
  factory $LocalOptionsStateCopyWith(
          LocalOptionsState value, $Res Function(LocalOptionsState) then) =
      _$LocalOptionsStateCopyWithImpl<$Res, LocalOptionsState>;
  @useResult
  $Res call(
      {ThemeMode themeMode,
      @ColorConverter() Color seedColor,
      bool useSystemSeedColor});
}

/// @nodoc
class _$LocalOptionsStateCopyWithImpl<$Res, $Val extends LocalOptionsState>
    implements $LocalOptionsStateCopyWith<$Res> {
  _$LocalOptionsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? seedColor = null,
    Object? useSystemSeedColor = null,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      seedColor: null == seedColor
          ? _value.seedColor
          : seedColor // ignore: cast_nullable_to_non_nullable
              as Color,
      useSystemSeedColor: null == useSystemSeedColor
          ? _value.useSystemSeedColor
          : useSystemSeedColor // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalOptionsStateImplCopyWith<$Res>
    implements $LocalOptionsStateCopyWith<$Res> {
  factory _$$LocalOptionsStateImplCopyWith(_$LocalOptionsStateImpl value,
          $Res Function(_$LocalOptionsStateImpl) then) =
      __$$LocalOptionsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ThemeMode themeMode,
      @ColorConverter() Color seedColor,
      bool useSystemSeedColor});
}

/// @nodoc
class __$$LocalOptionsStateImplCopyWithImpl<$Res>
    extends _$LocalOptionsStateCopyWithImpl<$Res, _$LocalOptionsStateImpl>
    implements _$$LocalOptionsStateImplCopyWith<$Res> {
  __$$LocalOptionsStateImplCopyWithImpl(_$LocalOptionsStateImpl _value,
      $Res Function(_$LocalOptionsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? seedColor = null,
    Object? useSystemSeedColor = null,
  }) {
    return _then(_$LocalOptionsStateImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      seedColor: null == seedColor
          ? _value.seedColor
          : seedColor // ignore: cast_nullable_to_non_nullable
              as Color,
      useSystemSeedColor: null == useSystemSeedColor
          ? _value.useSystemSeedColor
          : useSystemSeedColor // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocalOptionsStateImpl implements _LocalOptionsState {
  const _$LocalOptionsStateImpl(
      {required this.themeMode,
      @ColorConverter() required this.seedColor,
      required this.useSystemSeedColor});

  factory _$LocalOptionsStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocalOptionsStateImplFromJson(json);

  @override
  final ThemeMode themeMode;
  @override
  @ColorConverter()
  final Color seedColor;
  @override
  final bool useSystemSeedColor;

  @override
  String toString() {
    return 'LocalOptionsState(themeMode: $themeMode, seedColor: $seedColor, useSystemSeedColor: $useSystemSeedColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalOptionsStateImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.seedColor, seedColor) ||
                other.seedColor == seedColor) &&
            (identical(other.useSystemSeedColor, useSystemSeedColor) ||
                other.useSystemSeedColor == useSystemSeedColor));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, themeMode, seedColor, useSystemSeedColor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalOptionsStateImplCopyWith<_$LocalOptionsStateImpl> get copyWith =>
      __$$LocalOptionsStateImplCopyWithImpl<_$LocalOptionsStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocalOptionsStateImplToJson(
      this,
    );
  }
}

abstract class _LocalOptionsState implements LocalOptionsState {
  const factory _LocalOptionsState(
      {required final ThemeMode themeMode,
      @ColorConverter() required final Color seedColor,
      required final bool useSystemSeedColor}) = _$LocalOptionsStateImpl;

  factory _LocalOptionsState.fromJson(Map<String, dynamic> json) =
      _$LocalOptionsStateImpl.fromJson;

  @override
  ThemeMode get themeMode;
  @override
  @ColorConverter()
  Color get seedColor;
  @override
  bool get useSystemSeedColor;
  @override
  @JsonKey(ignore: true)
  _$$LocalOptionsStateImplCopyWith<_$LocalOptionsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

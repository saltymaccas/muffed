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
mixin _$PostState {
  PostStatus get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  PostView? get post => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PostStateCopyWith<PostState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostStateCopyWith<$Res> {
  factory $PostStateCopyWith(PostState value, $Res Function(PostState) then) =
      _$PostStateCopyWithImpl<$Res, PostState>;
  @useResult
  $Res call({PostStatus status, String? errorMessage, PostView? post});

  $PostViewCopyWith<$Res>? get post;
}

/// @nodoc
class _$PostStateCopyWithImpl<$Res, $Val extends PostState>
    implements $PostStateCopyWith<$Res> {
  _$PostStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? post = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PostStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      post: freezed == post
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as PostView?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PostViewCopyWith<$Res>? get post {
    if (_value.post == null) {
      return null;
    }

    return $PostViewCopyWith<$Res>(_value.post!, (value) {
      return _then(_value.copyWith(post: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostStateImplCopyWith<$Res>
    implements $PostStateCopyWith<$Res> {
  factory _$$PostStateImplCopyWith(
          _$PostStateImpl value, $Res Function(_$PostStateImpl) then) =
      __$$PostStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PostStatus status, String? errorMessage, PostView? post});

  @override
  $PostViewCopyWith<$Res>? get post;
}

/// @nodoc
class __$$PostStateImplCopyWithImpl<$Res>
    extends _$PostStateCopyWithImpl<$Res, _$PostStateImpl>
    implements _$$PostStateImplCopyWith<$Res> {
  __$$PostStateImplCopyWithImpl(
      _$PostStateImpl _value, $Res Function(_$PostStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? post = freezed,
  }) {
    return _then(_$PostStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PostStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      post: freezed == post
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as PostView?,
    ));
  }
}

/// @nodoc

class _$PostStateImpl implements _PostState {
  const _$PostStateImpl({required this.status, this.errorMessage, this.post});

  @override
  final PostStatus status;
  @override
  final String? errorMessage;
  @override
  final PostView? post;

  @override
  String toString() {
    return 'PostState(status: $status, errorMessage: $errorMessage, post: $post)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.post, post) || other.post == post));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, errorMessage, post);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostStateImplCopyWith<_$PostStateImpl> get copyWith =>
      __$$PostStateImplCopyWithImpl<_$PostStateImpl>(this, _$identity);
}

abstract class _PostState implements PostState {
  const factory _PostState(
      {required final PostStatus status,
      final String? errorMessage,
      final PostView? post}) = _$PostStateImpl;

  @override
  PostStatus get status;
  @override
  String? get errorMessage;
  @override
  PostView? get post;
  @override
  @JsonKey(ignore: true)
  _$$PostStateImplCopyWith<_$PostStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

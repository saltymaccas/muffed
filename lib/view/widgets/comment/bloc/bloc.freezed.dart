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
mixin _$CommentState {
  CommentTree get commentTree => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CommentStateCopyWith<CommentState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentStateCopyWith<$Res> {
  factory $CommentStateCopyWith(
          CommentState value, $Res Function(CommentState) then) =
      _$CommentStateCopyWithImpl<$Res, CommentState>;
  @useResult
  $Res call({CommentTree commentTree});

  $CommentTreeCopyWith<$Res> get commentTree;
}

/// @nodoc
class _$CommentStateCopyWithImpl<$Res, $Val extends CommentState>
    implements $CommentStateCopyWith<$Res> {
  _$CommentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentTree = null,
  }) {
    return _then(_value.copyWith(
      commentTree: null == commentTree
          ? _value.commentTree
          : commentTree // ignore: cast_nullable_to_non_nullable
              as CommentTree,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CommentTreeCopyWith<$Res> get commentTree {
    return $CommentTreeCopyWith<$Res>(_value.commentTree, (value) {
      return _then(_value.copyWith(commentTree: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentStateImplCopyWith<$Res>
    implements $CommentStateCopyWith<$Res> {
  factory _$$CommentStateImplCopyWith(
          _$CommentStateImpl value, $Res Function(_$CommentStateImpl) then) =
      __$$CommentStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CommentTree commentTree});

  @override
  $CommentTreeCopyWith<$Res> get commentTree;
}

/// @nodoc
class __$$CommentStateImplCopyWithImpl<$Res>
    extends _$CommentStateCopyWithImpl<$Res, _$CommentStateImpl>
    implements _$$CommentStateImplCopyWith<$Res> {
  __$$CommentStateImplCopyWithImpl(
      _$CommentStateImpl _value, $Res Function(_$CommentStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentTree = null,
  }) {
    return _then(_$CommentStateImpl(
      commentTree: null == commentTree
          ? _value.commentTree
          : commentTree // ignore: cast_nullable_to_non_nullable
              as CommentTree,
    ));
  }
}

/// @nodoc

class _$CommentStateImpl implements _CommentState {
  const _$CommentStateImpl({required this.commentTree});

  @override
  final CommentTree commentTree;

  @override
  String toString() {
    return 'CommentState(commentTree: $commentTree)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentStateImpl &&
            (identical(other.commentTree, commentTree) ||
                other.commentTree == commentTree));
  }

  @override
  int get hashCode => Object.hash(runtimeType, commentTree);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentStateImplCopyWith<_$CommentStateImpl> get copyWith =>
      __$$CommentStateImplCopyWithImpl<_$CommentStateImpl>(this, _$identity);
}

abstract class _CommentState implements CommentState {
  const factory _CommentState({required final CommentTree commentTree}) =
      _$CommentStateImpl;

  @override
  CommentTree get commentTree;
  @override
  @JsonKey(ignore: true)
  _$$CommentStateImplCopyWith<_$CommentStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

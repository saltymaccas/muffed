// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CommentTree {
  CommentView get comment => throw _privateConstructorUsedError;
  List<CommentTree> get children => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CommentTreeCopyWith<CommentTree> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentTreeCopyWith<$Res> {
  factory $CommentTreeCopyWith(
          CommentTree value, $Res Function(CommentTree) then) =
      _$CommentTreeCopyWithImpl<$Res, CommentTree>;
  @useResult
  $Res call({CommentView comment, List<CommentTree> children});

  $CommentViewCopyWith<$Res> get comment;
}

/// @nodoc
class _$CommentTreeCopyWithImpl<$Res, $Val extends CommentTree>
    implements $CommentTreeCopyWith<$Res> {
  _$CommentTreeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comment = null,
    Object? children = null,
  }) {
    return _then(_value.copyWith(
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as CommentView,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<CommentTree>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CommentViewCopyWith<$Res> get comment {
    return $CommentViewCopyWith<$Res>(_value.comment, (value) {
      return _then(_value.copyWith(comment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentTreeImplCopyWith<$Res>
    implements $CommentTreeCopyWith<$Res> {
  factory _$$CommentTreeImplCopyWith(
          _$CommentTreeImpl value, $Res Function(_$CommentTreeImpl) then) =
      __$$CommentTreeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CommentView comment, List<CommentTree> children});

  @override
  $CommentViewCopyWith<$Res> get comment;
}

/// @nodoc
class __$$CommentTreeImplCopyWithImpl<$Res>
    extends _$CommentTreeCopyWithImpl<$Res, _$CommentTreeImpl>
    implements _$$CommentTreeImplCopyWith<$Res> {
  __$$CommentTreeImplCopyWithImpl(
      _$CommentTreeImpl _value, $Res Function(_$CommentTreeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comment = null,
    Object? children = null,
  }) {
    return _then(_$CommentTreeImpl(
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as CommentView,
      children: null == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<CommentTree>,
    ));
  }
}

/// @nodoc

class _$CommentTreeImpl implements _CommentTree {
  const _$CommentTreeImpl(
      {required this.comment, required final List<CommentTree> children})
      : _children = children;

  @override
  final CommentView comment;
  final List<CommentTree> _children;
  @override
  List<CommentTree> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  String toString() {
    return 'CommentTree(comment: $comment, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentTreeImpl &&
            (identical(other.comment, comment) || other.comment == comment) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, comment, const DeepCollectionEquality().hash(_children));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentTreeImplCopyWith<_$CommentTreeImpl> get copyWith =>
      __$$CommentTreeImplCopyWithImpl<_$CommentTreeImpl>(this, _$identity);
}

abstract class _CommentTree implements CommentTree {
  const factory _CommentTree(
      {required final CommentView comment,
      required final List<CommentTree> children}) = _$CommentTreeImpl;

  @override
  CommentView get comment;
  @override
  List<CommentTree> get children;
  @override
  @JsonKey(ignore: true)
  _$$CommentTreeImplCopyWith<_$CommentTreeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

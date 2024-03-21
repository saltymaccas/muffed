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
mixin _$CommentScrollState {
  PagedScrollViewStatus get status => throw _privateConstructorUsedError;
  int get pagesLoaded => throw _privateConstructorUsedError;
  bool get allPagedLoaded => throw _privateConstructorUsedError;
  CommentSortType get sort => throw _privateConstructorUsedError;
  List<CommentTree>? get comments => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CommentScrollStateCopyWith<CommentScrollState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentScrollStateCopyWith<$Res> {
  factory $CommentScrollStateCopyWith(
          CommentScrollState value, $Res Function(CommentScrollState) then) =
      _$CommentScrollStateCopyWithImpl<$Res, CommentScrollState>;
  @useResult
  $Res call(
      {PagedScrollViewStatus status,
      int pagesLoaded,
      bool allPagedLoaded,
      CommentSortType sort,
      List<CommentTree>? comments});
}

/// @nodoc
class _$CommentScrollStateCopyWithImpl<$Res, $Val extends CommentScrollState>
    implements $CommentScrollStateCopyWith<$Res> {
  _$CommentScrollStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? pagesLoaded = null,
    Object? allPagedLoaded = null,
    Object? sort = freezed,
    Object? comments = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PagedScrollViewStatus,
      pagesLoaded: null == pagesLoaded
          ? _value.pagesLoaded
          : pagesLoaded // ignore: cast_nullable_to_non_nullable
              as int,
      allPagedLoaded: null == allPagedLoaded
          ? _value.allPagedLoaded
          : allPagedLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      sort: freezed == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as CommentSortType,
      comments: freezed == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<CommentTree>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentScrollStateImplCopyWith<$Res>
    implements $CommentScrollStateCopyWith<$Res> {
  factory _$$CommentScrollStateImplCopyWith(_$CommentScrollStateImpl value,
          $Res Function(_$CommentScrollStateImpl) then) =
      __$$CommentScrollStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PagedScrollViewStatus status,
      int pagesLoaded,
      bool allPagedLoaded,
      CommentSortType sort,
      List<CommentTree>? comments});
}

/// @nodoc
class __$$CommentScrollStateImplCopyWithImpl<$Res>
    extends _$CommentScrollStateCopyWithImpl<$Res, _$CommentScrollStateImpl>
    implements _$$CommentScrollStateImplCopyWith<$Res> {
  __$$CommentScrollStateImplCopyWithImpl(_$CommentScrollStateImpl _value,
      $Res Function(_$CommentScrollStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? pagesLoaded = null,
    Object? allPagedLoaded = null,
    Object? sort = freezed,
    Object? comments = freezed,
  }) {
    return _then(_$CommentScrollStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PagedScrollViewStatus,
      pagesLoaded: null == pagesLoaded
          ? _value.pagesLoaded
          : pagesLoaded // ignore: cast_nullable_to_non_nullable
              as int,
      allPagedLoaded: null == allPagedLoaded
          ? _value.allPagedLoaded
          : allPagedLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      sort: freezed == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as CommentSortType,
      comments: freezed == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<CommentTree>?,
    ));
  }
}

/// @nodoc

class _$CommentScrollStateImpl implements _CommentScrollState {
  const _$CommentScrollStateImpl(
      {required this.status,
      required this.pagesLoaded,
      required this.allPagedLoaded,
      required this.sort,
      final List<CommentTree>? comments})
      : _comments = comments;

  @override
  final PagedScrollViewStatus status;
  @override
  final int pagesLoaded;
  @override
  final bool allPagedLoaded;
  @override
  final CommentSortType sort;
  final List<CommentTree>? _comments;
  @override
  List<CommentTree>? get comments {
    final value = _comments;
    if (value == null) return null;
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CommentScrollState(status: $status, pagesLoaded: $pagesLoaded, allPagedLoaded: $allPagedLoaded, sort: $sort, comments: $comments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentScrollStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.pagesLoaded, pagesLoaded) ||
                other.pagesLoaded == pagesLoaded) &&
            (identical(other.allPagedLoaded, allPagedLoaded) ||
                other.allPagedLoaded == allPagedLoaded) &&
            const DeepCollectionEquality().equals(other.sort, sort) &&
            const DeepCollectionEquality().equals(other._comments, _comments));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      pagesLoaded,
      allPagedLoaded,
      const DeepCollectionEquality().hash(sort),
      const DeepCollectionEquality().hash(_comments));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentScrollStateImplCopyWith<_$CommentScrollStateImpl> get copyWith =>
      __$$CommentScrollStateImplCopyWithImpl<_$CommentScrollStateImpl>(
          this, _$identity);
}

abstract class _CommentScrollState implements CommentScrollState {
  const factory _CommentScrollState(
      {required final PagedScrollViewStatus status,
      required final int pagesLoaded,
      required final bool allPagedLoaded,
      required final CommentSortType sort,
      final List<CommentTree>? comments}) = _$CommentScrollStateImpl;

  @override
  PagedScrollViewStatus get status;
  @override
  int get pagesLoaded;
  @override
  bool get allPagedLoaded;
  @override
  CommentSortType get sort;
  @override
  List<CommentTree>? get comments;
  @override
  @JsonKey(ignore: true)
  _$$CommentScrollStateImplCopyWith<_$CommentScrollStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

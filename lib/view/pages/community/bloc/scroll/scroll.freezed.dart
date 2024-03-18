// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scroll.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CommunityScrollState {
  PagedScrollViewStatus get status => throw _privateConstructorUsedError;
  int get pagesLoaded => throw _privateConstructorUsedError;
  LemmySortType get sort => throw _privateConstructorUsedError;
  List<LemmyPost>? get posts => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CommunityScrollStateCopyWith<CommunityScrollState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityScrollStateCopyWith<$Res> {
  factory $CommunityScrollStateCopyWith(CommunityScrollState value,
          $Res Function(CommunityScrollState) then) =
      _$CommunityScrollStateCopyWithImpl<$Res, CommunityScrollState>;
  @useResult
  $Res call(
      {PagedScrollViewStatus status,
      int pagesLoaded,
      LemmySortType sort,
      List<LemmyPost>? posts,
      String? errorMessage});
}

/// @nodoc
class _$CommunityScrollStateCopyWithImpl<$Res,
        $Val extends CommunityScrollState>
    implements $CommunityScrollStateCopyWith<$Res> {
  _$CommunityScrollStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? pagesLoaded = null,
    Object? sort = null,
    Object? posts = freezed,
    Object? errorMessage = freezed,
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
      sort: null == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as LemmySortType,
      posts: freezed == posts
          ? _value.posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<LemmyPost>?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommunityScrollStateImplCopyWith<$Res>
    implements $CommunityScrollStateCopyWith<$Res> {
  factory _$$CommunityScrollStateImplCopyWith(_$CommunityScrollStateImpl value,
          $Res Function(_$CommunityScrollStateImpl) then) =
      __$$CommunityScrollStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PagedScrollViewStatus status,
      int pagesLoaded,
      LemmySortType sort,
      List<LemmyPost>? posts,
      String? errorMessage});
}

/// @nodoc
class __$$CommunityScrollStateImplCopyWithImpl<$Res>
    extends _$CommunityScrollStateCopyWithImpl<$Res, _$CommunityScrollStateImpl>
    implements _$$CommunityScrollStateImplCopyWith<$Res> {
  __$$CommunityScrollStateImplCopyWithImpl(_$CommunityScrollStateImpl _value,
      $Res Function(_$CommunityScrollStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? pagesLoaded = null,
    Object? sort = null,
    Object? posts = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$CommunityScrollStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PagedScrollViewStatus,
      pagesLoaded: null == pagesLoaded
          ? _value.pagesLoaded
          : pagesLoaded // ignore: cast_nullable_to_non_nullable
              as int,
      sort: null == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as LemmySortType,
      posts: freezed == posts
          ? _value._posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<LemmyPost>?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CommunityScrollStateImpl implements _CommunityScrollState {
  const _$CommunityScrollStateImpl(
      {required this.status,
      required this.pagesLoaded,
      required this.sort,
      final List<LemmyPost>? posts,
      this.errorMessage})
      : _posts = posts;

  @override
  final PagedScrollViewStatus status;
  @override
  final int pagesLoaded;
  @override
  final LemmySortType sort;
  final List<LemmyPost>? _posts;
  @override
  List<LemmyPost>? get posts {
    final value = _posts;
    if (value == null) return null;
    if (_posts is EqualUnmodifiableListView) return _posts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'CommunityScrollState(status: $status, pagesLoaded: $pagesLoaded, sort: $sort, posts: $posts, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityScrollStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.pagesLoaded, pagesLoaded) ||
                other.pagesLoaded == pagesLoaded) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            const DeepCollectionEquality().equals(other._posts, _posts) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, pagesLoaded, sort,
      const DeepCollectionEquality().hash(_posts), errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityScrollStateImplCopyWith<_$CommunityScrollStateImpl>
      get copyWith =>
          __$$CommunityScrollStateImplCopyWithImpl<_$CommunityScrollStateImpl>(
              this, _$identity);
}

abstract class _CommunityScrollState implements CommunityScrollState {
  const factory _CommunityScrollState(
      {required final PagedScrollViewStatus status,
      required final int pagesLoaded,
      required final LemmySortType sort,
      final List<LemmyPost>? posts,
      final String? errorMessage}) = _$CommunityScrollStateImpl;

  @override
  PagedScrollViewStatus get status;
  @override
  int get pagesLoaded;
  @override
  LemmySortType get sort;
  @override
  List<LemmyPost>? get posts;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$CommunityScrollStateImplCopyWith<_$CommunityScrollStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

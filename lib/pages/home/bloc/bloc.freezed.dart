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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HomeState {
  bool get loading => throw _privateConstructorUsedError;
  bool get reloading => throw _privateConstructorUsedError;
  bool get loadingMore => throw _privateConstructorUsedError;
  bool get loadedAllPages => throw _privateConstructorUsedError;
  SortType get sort => throw _privateConstructorUsedError;
  int get pagesLoaded => throw _privateConstructorUsedError;
  List<PostView>? get posts => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call(
      {bool loading,
      bool reloading,
      bool loadingMore,
      bool loadedAllPages,
      SortType sort,
      int pagesLoaded,
      List<PostView>? posts,
      Object? error});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? reloading = null,
    Object? loadingMore = null,
    Object? loadedAllPages = null,
    Object? sort = null,
    Object? pagesLoaded = null,
    Object? posts = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      reloading: null == reloading
          ? _value.reloading
          : reloading // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingMore: null == loadingMore
          ? _value.loadingMore
          : loadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      loadedAllPages: null == loadedAllPages
          ? _value.loadedAllPages
          : loadedAllPages // ignore: cast_nullable_to_non_nullable
              as bool,
      sort: null == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as SortType,
      pagesLoaded: null == pagesLoaded
          ? _value.pagesLoaded
          : pagesLoaded // ignore: cast_nullable_to_non_nullable
              as int,
      posts: freezed == posts
          ? _value.posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<PostView>?,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
          _$HomeStateImpl value, $Res Function(_$HomeStateImpl) then) =
      __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      bool reloading,
      bool loadingMore,
      bool loadedAllPages,
      SortType sort,
      int pagesLoaded,
      List<PostView>? posts,
      Object? error});
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
      _$HomeStateImpl _value, $Res Function(_$HomeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? reloading = null,
    Object? loadingMore = null,
    Object? loadedAllPages = null,
    Object? sort = null,
    Object? pagesLoaded = null,
    Object? posts = freezed,
    Object? error = freezed,
  }) {
    return _then(_$HomeStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      reloading: null == reloading
          ? _value.reloading
          : reloading // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingMore: null == loadingMore
          ? _value.loadingMore
          : loadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      loadedAllPages: null == loadedAllPages
          ? _value.loadedAllPages
          : loadedAllPages // ignore: cast_nullable_to_non_nullable
              as bool,
      sort: null == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as SortType,
      pagesLoaded: null == pagesLoaded
          ? _value.pagesLoaded
          : pagesLoaded // ignore: cast_nullable_to_non_nullable
              as int,
      posts: freezed == posts
          ? _value._posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<PostView>?,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl(
      {required this.loading,
      required this.reloading,
      required this.loadingMore,
      required this.loadedAllPages,
      required this.sort,
      required this.pagesLoaded,
      final List<PostView>? posts,
      this.error = null})
      : _posts = posts;

  @override
  final bool loading;
  @override
  final bool reloading;
  @override
  final bool loadingMore;
  @override
  final bool loadedAllPages;
  @override
  final SortType sort;
  @override
  final int pagesLoaded;
  final List<PostView>? _posts;
  @override
  List<PostView>? get posts {
    final value = _posts;
    if (value == null) return null;
    if (_posts is EqualUnmodifiableListView) return _posts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final Object? error;

  @override
  String toString() {
    return 'HomeState(loading: $loading, reloading: $reloading, loadingMore: $loadingMore, loadedAllPages: $loadedAllPages, sort: $sort, pagesLoaded: $pagesLoaded, posts: $posts, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.reloading, reloading) ||
                other.reloading == reloading) &&
            (identical(other.loadingMore, loadingMore) ||
                other.loadingMore == loadingMore) &&
            (identical(other.loadedAllPages, loadedAllPages) ||
                other.loadedAllPages == loadedAllPages) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.pagesLoaded, pagesLoaded) ||
                other.pagesLoaded == pagesLoaded) &&
            const DeepCollectionEquality().equals(other._posts, _posts) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      reloading,
      loadingMore,
      loadedAllPages,
      sort,
      pagesLoaded,
      const DeepCollectionEquality().hash(_posts),
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState(
      {required final bool loading,
      required final bool reloading,
      required final bool loadingMore,
      required final bool loadedAllPages,
      required final SortType sort,
      required final int pagesLoaded,
      final List<PostView>? posts,
      final Object? error}) = _$HomeStateImpl;

  @override
  bool get loading;
  @override
  bool get reloading;
  @override
  bool get loadingMore;
  @override
  bool get loadedAllPages;
  @override
  SortType get sort;
  @override
  int get pagesLoaded;
  @override
  List<PostView>? get posts;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

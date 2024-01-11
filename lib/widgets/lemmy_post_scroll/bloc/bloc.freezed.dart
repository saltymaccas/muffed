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
mixin _$LemmyPostScrollState {
  HomeStateStatus get status => throw _privateConstructorUsedError;
  bool get allPagesLoaded => throw _privateConstructorUsedError;
  GetPosts get selectedQuery => throw _privateConstructorUsedError;
  GetPosts? get loadedQuery => throw _privateConstructorUsedError;
  int get pagesLoaded => throw _privateConstructorUsedError;
  Object? get exception => throw _privateConstructorUsedError;
  LemmyPostScrollEvent? get lastEvent => throw _privateConstructorUsedError;
  List<PostView>? get posts => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LemmyPostScrollStateCopyWith<LemmyPostScrollState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LemmyPostScrollStateCopyWith<$Res> {
  factory $LemmyPostScrollStateCopyWith(LemmyPostScrollState value,
          $Res Function(LemmyPostScrollState) then) =
      _$LemmyPostScrollStateCopyWithImpl<$Res, LemmyPostScrollState>;
  @useResult
  $Res call(
      {HomeStateStatus status,
      bool allPagesLoaded,
      GetPosts selectedQuery,
      GetPosts? loadedQuery,
      int pagesLoaded,
      Object? exception,
      LemmyPostScrollEvent? lastEvent,
      List<PostView>? posts});

  $GetPostsCopyWith<$Res> get selectedQuery;
  $GetPostsCopyWith<$Res>? get loadedQuery;
}

/// @nodoc
class _$LemmyPostScrollStateCopyWithImpl<$Res,
        $Val extends LemmyPostScrollState>
    implements $LemmyPostScrollStateCopyWith<$Res> {
  _$LemmyPostScrollStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? allPagesLoaded = null,
    Object? selectedQuery = null,
    Object? loadedQuery = freezed,
    Object? pagesLoaded = null,
    Object? exception = freezed,
    Object? lastEvent = freezed,
    Object? posts = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as HomeStateStatus,
      allPagesLoaded: null == allPagesLoaded
          ? _value.allPagesLoaded
          : allPagesLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedQuery: null == selectedQuery
          ? _value.selectedQuery
          : selectedQuery // ignore: cast_nullable_to_non_nullable
              as GetPosts,
      loadedQuery: freezed == loadedQuery
          ? _value.loadedQuery
          : loadedQuery // ignore: cast_nullable_to_non_nullable
              as GetPosts?,
      pagesLoaded: null == pagesLoaded
          ? _value.pagesLoaded
          : pagesLoaded // ignore: cast_nullable_to_non_nullable
              as int,
      exception: freezed == exception ? _value.exception : exception,
      lastEvent: freezed == lastEvent
          ? _value.lastEvent
          : lastEvent // ignore: cast_nullable_to_non_nullable
              as LemmyPostScrollEvent?,
      posts: freezed == posts
          ? _value.posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<PostView>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GetPostsCopyWith<$Res> get selectedQuery {
    return $GetPostsCopyWith<$Res>(_value.selectedQuery, (value) {
      return _then(_value.copyWith(selectedQuery: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GetPostsCopyWith<$Res>? get loadedQuery {
    if (_value.loadedQuery == null) {
      return null;
    }

    return $GetPostsCopyWith<$Res>(_value.loadedQuery!, (value) {
      return _then(_value.copyWith(loadedQuery: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LemmyPostScrollStateImplCopyWith<$Res>
    implements $LemmyPostScrollStateCopyWith<$Res> {
  factory _$$LemmyPostScrollStateImplCopyWith(_$LemmyPostScrollStateImpl value,
          $Res Function(_$LemmyPostScrollStateImpl) then) =
      __$$LemmyPostScrollStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {HomeStateStatus status,
      bool allPagesLoaded,
      GetPosts selectedQuery,
      GetPosts? loadedQuery,
      int pagesLoaded,
      Object? exception,
      LemmyPostScrollEvent? lastEvent,
      List<PostView>? posts});

  @override
  $GetPostsCopyWith<$Res> get selectedQuery;
  @override
  $GetPostsCopyWith<$Res>? get loadedQuery;
}

/// @nodoc
class __$$LemmyPostScrollStateImplCopyWithImpl<$Res>
    extends _$LemmyPostScrollStateCopyWithImpl<$Res, _$LemmyPostScrollStateImpl>
    implements _$$LemmyPostScrollStateImplCopyWith<$Res> {
  __$$LemmyPostScrollStateImplCopyWithImpl(_$LemmyPostScrollStateImpl _value,
      $Res Function(_$LemmyPostScrollStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? allPagesLoaded = null,
    Object? selectedQuery = null,
    Object? loadedQuery = freezed,
    Object? pagesLoaded = null,
    Object? exception = freezed,
    Object? lastEvent = freezed,
    Object? posts = freezed,
  }) {
    return _then(_$LemmyPostScrollStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as HomeStateStatus,
      allPagesLoaded: null == allPagesLoaded
          ? _value.allPagesLoaded
          : allPagesLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedQuery: null == selectedQuery
          ? _value.selectedQuery
          : selectedQuery // ignore: cast_nullable_to_non_nullable
              as GetPosts,
      loadedQuery: freezed == loadedQuery
          ? _value.loadedQuery
          : loadedQuery // ignore: cast_nullable_to_non_nullable
              as GetPosts?,
      pagesLoaded: null == pagesLoaded
          ? _value.pagesLoaded
          : pagesLoaded // ignore: cast_nullable_to_non_nullable
              as int,
      exception: freezed == exception ? _value.exception : exception,
      lastEvent: freezed == lastEvent
          ? _value.lastEvent
          : lastEvent // ignore: cast_nullable_to_non_nullable
              as LemmyPostScrollEvent?,
      posts: freezed == posts
          ? _value._posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<PostView>?,
    ));
  }
}

/// @nodoc

class _$LemmyPostScrollStateImpl extends _LemmyPostScrollState {
  const _$LemmyPostScrollStateImpl(
      {required this.status,
      required this.allPagesLoaded,
      required this.selectedQuery,
      required this.loadedQuery,
      required this.pagesLoaded,
      this.exception,
      this.lastEvent,
      final List<PostView>? posts})
      : _posts = posts,
        super._();

  @override
  final HomeStateStatus status;
  @override
  final bool allPagesLoaded;
  @override
  final GetPosts selectedQuery;
  @override
  final GetPosts? loadedQuery;
  @override
  final int pagesLoaded;
  @override
  final Object? exception;
  @override
  final LemmyPostScrollEvent? lastEvent;
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
  String toString() {
    return 'LemmyPostScrollState(status: $status, allPagesLoaded: $allPagesLoaded, selectedQuery: $selectedQuery, loadedQuery: $loadedQuery, pagesLoaded: $pagesLoaded, exception: $exception, lastEvent: $lastEvent, posts: $posts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LemmyPostScrollStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.allPagesLoaded, allPagesLoaded) ||
                other.allPagesLoaded == allPagesLoaded) &&
            (identical(other.selectedQuery, selectedQuery) ||
                other.selectedQuery == selectedQuery) &&
            (identical(other.loadedQuery, loadedQuery) ||
                other.loadedQuery == loadedQuery) &&
            (identical(other.pagesLoaded, pagesLoaded) ||
                other.pagesLoaded == pagesLoaded) &&
            const DeepCollectionEquality().equals(other.exception, exception) &&
            (identical(other.lastEvent, lastEvent) ||
                other.lastEvent == lastEvent) &&
            const DeepCollectionEquality().equals(other._posts, _posts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      allPagesLoaded,
      selectedQuery,
      loadedQuery,
      pagesLoaded,
      const DeepCollectionEquality().hash(exception),
      lastEvent,
      const DeepCollectionEquality().hash(_posts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LemmyPostScrollStateImplCopyWith<_$LemmyPostScrollStateImpl>
      get copyWith =>
          __$$LemmyPostScrollStateImplCopyWithImpl<_$LemmyPostScrollStateImpl>(
              this, _$identity);
}

abstract class _LemmyPostScrollState extends LemmyPostScrollState {
  const factory _LemmyPostScrollState(
      {required final HomeStateStatus status,
      required final bool allPagesLoaded,
      required final GetPosts selectedQuery,
      required final GetPosts? loadedQuery,
      required final int pagesLoaded,
      final Object? exception,
      final LemmyPostScrollEvent? lastEvent,
      final List<PostView>? posts}) = _$LemmyPostScrollStateImpl;
  const _LemmyPostScrollState._() : super._();

  @override
  HomeStateStatus get status;
  @override
  bool get allPagesLoaded;
  @override
  GetPosts get selectedQuery;
  @override
  GetPosts? get loadedQuery;
  @override
  int get pagesLoaded;
  @override
  Object? get exception;
  @override
  LemmyPostScrollEvent? get lastEvent;
  @override
  List<PostView>? get posts;
  @override
  @JsonKey(ignore: true)
  _$$LemmyPostScrollStateImplCopyWith<_$LemmyPostScrollStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

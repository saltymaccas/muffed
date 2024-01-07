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
  HomeStateStatus get status => throw _privateConstructorUsedError;
  bool get loadedAllPages => throw _privateConstructorUsedError;
  SortType get selectedSort => throw _privateConstructorUsedError;
  SortType get loadedSort => throw _privateConstructorUsedError;
  int get pagesLoaded => throw _privateConstructorUsedError;
  Object? get exception => throw _privateConstructorUsedError;
  LemmyPostScrollEvent? get lastEvent => throw _privateConstructorUsedError;
  List<PostView>? get posts => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeStateCopyWith<LemmyPostScrollState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(LemmyPostScrollState value,
          $Res Function(LemmyPostScrollState) then) =
      _$HomeStateCopyWithImpl<$Res, LemmyPostScrollState>;
  @useResult
  $Res call(
      {HomeStateStatus status,
      bool loadedAllPages,
      SortType selectedSort,
      SortType loadedSort,
      int pagesLoaded,
      Object? exception,
      LemmyPostScrollEvent? lastEvent,
      List<PostView>? posts});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends LemmyPostScrollState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? loadedAllPages = null,
    Object? selectedSort = null,
    Object? loadedSort = null,
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
      loadedAllPages: null == loadedAllPages
          ? _value.loadedAllPages
          : loadedAllPages // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedSort: null == selectedSort
          ? _value.selectedSort
          : selectedSort // ignore: cast_nullable_to_non_nullable
              as SortType,
      loadedSort: null == loadedSort
          ? _value.loadedSort
          : loadedSort // ignore: cast_nullable_to_non_nullable
              as SortType,
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
      {HomeStateStatus status,
      bool loadedAllPages,
      SortType selectedSort,
      SortType loadedSort,
      int pagesLoaded,
      Object? exception,
      LemmyPostScrollEvent? lastEvent,
      List<PostView>? posts});
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
    Object? status = null,
    Object? loadedAllPages = null,
    Object? selectedSort = null,
    Object? loadedSort = null,
    Object? pagesLoaded = null,
    Object? exception = freezed,
    Object? lastEvent = freezed,
    Object? posts = freezed,
  }) {
    return _then(_$HomeStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as HomeStateStatus,
      loadedAllPages: null == loadedAllPages
          ? _value.loadedAllPages
          : loadedAllPages // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedSort: null == selectedSort
          ? _value.selectedSort
          : selectedSort // ignore: cast_nullable_to_non_nullable
              as SortType,
      loadedSort: null == loadedSort
          ? _value.loadedSort
          : loadedSort // ignore: cast_nullable_to_non_nullable
              as SortType,
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

class _$HomeStateImpl extends _HomeState {
  const _$HomeStateImpl(
      {required this.status,
      required this.loadedAllPages,
      required this.selectedSort,
      required this.loadedSort,
      required this.pagesLoaded,
      this.exception,
      this.lastEvent,
      final List<PostView>? posts})
      : _posts = posts,
        super._();

  @override
  final HomeStateStatus status;
  @override
  final bool loadedAllPages;
  @override
  final SortType selectedSort;
  @override
  final SortType loadedSort;
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
    return 'HomeState(status: $status, loadedAllPages: $loadedAllPages, selectedSort: $selectedSort, loadedSort: $loadedSort, pagesLoaded: $pagesLoaded, exception: $exception, lastEvent: $lastEvent, posts: $posts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.loadedAllPages, loadedAllPages) ||
                other.loadedAllPages == loadedAllPages) &&
            (identical(other.selectedSort, selectedSort) ||
                other.selectedSort == selectedSort) &&
            (identical(other.loadedSort, loadedSort) ||
                other.loadedSort == loadedSort) &&
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
      loadedAllPages,
      selectedSort,
      loadedSort,
      pagesLoaded,
      const DeepCollectionEquality().hash(exception),
      lastEvent,
      const DeepCollectionEquality().hash(_posts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState extends LemmyPostScrollState {
  const factory _HomeState(
      {required final HomeStateStatus status,
      required final bool loadedAllPages,
      required final SortType selectedSort,
      required final SortType loadedSort,
      required final int pagesLoaded,
      final Object? exception,
      final LemmyPostScrollEvent? lastEvent,
      final List<PostView>? posts}) = _$HomeStateImpl;
  const _HomeState._() : super._();

  @override
  HomeStateStatus get status;
  @override
  bool get loadedAllPages;
  @override
  SortType get selectedSort;
  @override
  SortType get loadedSort;
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
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

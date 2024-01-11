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
mixin _$PagedContentState {
  PagedContentLoadingState? get loadingState =>
      throw _privateConstructorUsedError;
  PagedContentLoadedState? get loadedState =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PagedContentStateCopyWith<PagedContentState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagedContentStateCopyWith<$Res> {
  factory $PagedContentStateCopyWith(
          PagedContentState value, $Res Function(PagedContentState) then) =
      _$PagedContentStateCopyWithImpl<$Res, PagedContentState>;
  @useResult
  $Res call(
      {PagedContentLoadingState? loadingState,
      PagedContentLoadedState? loadedState});

  $PagedContentLoadingStateCopyWith<$Res>? get loadingState;
  $PagedContentLoadedStateCopyWith<$Res>? get loadedState;
}

/// @nodoc
class _$PagedContentStateCopyWithImpl<$Res, $Val extends PagedContentState>
    implements $PagedContentStateCopyWith<$Res> {
  _$PagedContentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadingState = freezed,
    Object? loadedState = freezed,
  }) {
    return _then(_value.copyWith(
      loadingState: freezed == loadingState
          ? _value.loadingState
          : loadingState // ignore: cast_nullable_to_non_nullable
              as PagedContentLoadingState?,
      loadedState: freezed == loadedState
          ? _value.loadedState
          : loadedState // ignore: cast_nullable_to_non_nullable
              as PagedContentLoadedState?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PagedContentLoadingStateCopyWith<$Res>? get loadingState {
    if (_value.loadingState == null) {
      return null;
    }

    return $PagedContentLoadingStateCopyWith<$Res>(_value.loadingState!,
        (value) {
      return _then(_value.copyWith(loadingState: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PagedContentLoadedStateCopyWith<$Res>? get loadedState {
    if (_value.loadedState == null) {
      return null;
    }

    return $PagedContentLoadedStateCopyWith<$Res>(_value.loadedState!, (value) {
      return _then(_value.copyWith(loadedState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PagedContentStateImplCopyWith<$Res>
    implements $PagedContentStateCopyWith<$Res> {
  factory _$$PagedContentStateImplCopyWith(_$PagedContentStateImpl value,
          $Res Function(_$PagedContentStateImpl) then) =
      __$$PagedContentStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PagedContentLoadingState? loadingState,
      PagedContentLoadedState? loadedState});

  @override
  $PagedContentLoadingStateCopyWith<$Res>? get loadingState;
  @override
  $PagedContentLoadedStateCopyWith<$Res>? get loadedState;
}

/// @nodoc
class __$$PagedContentStateImplCopyWithImpl<$Res>
    extends _$PagedContentStateCopyWithImpl<$Res, _$PagedContentStateImpl>
    implements _$$PagedContentStateImplCopyWith<$Res> {
  __$$PagedContentStateImplCopyWithImpl(_$PagedContentStateImpl _value,
      $Res Function(_$PagedContentStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadingState = freezed,
    Object? loadedState = freezed,
  }) {
    return _then(_$PagedContentStateImpl(
      loadingState: freezed == loadingState
          ? _value.loadingState
          : loadingState // ignore: cast_nullable_to_non_nullable
              as PagedContentLoadingState?,
      loadedState: freezed == loadedState
          ? _value.loadedState
          : loadedState // ignore: cast_nullable_to_non_nullable
              as PagedContentLoadedState?,
    ));
  }
}

/// @nodoc

class _$PagedContentStateImpl extends _PagedContentState {
  const _$PagedContentStateImpl({this.loadingState, this.loadedState})
      : super._();

  @override
  final PagedContentLoadingState? loadingState;
  @override
  final PagedContentLoadedState? loadedState;

  @override
  String toString() {
    return 'PagedContentState(loadingState: $loadingState, loadedState: $loadedState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PagedContentStateImpl &&
            (identical(other.loadingState, loadingState) ||
                other.loadingState == loadingState) &&
            (identical(other.loadedState, loadedState) ||
                other.loadedState == loadedState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loadingState, loadedState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PagedContentStateImplCopyWith<_$PagedContentStateImpl> get copyWith =>
      __$$PagedContentStateImplCopyWithImpl<_$PagedContentStateImpl>(
          this, _$identity);
}

abstract class _PagedContentState extends PagedContentState {
  const factory _PagedContentState(
      {final PagedContentLoadingState? loadingState,
      final PagedContentLoadedState? loadedState}) = _$PagedContentStateImpl;
  const _PagedContentState._() : super._();

  @override
  PagedContentLoadingState? get loadingState;
  @override
  PagedContentLoadedState? get loadedState;
  @override
  @JsonKey(ignore: true)
  _$$PagedContentStateImplCopyWith<_$PagedContentStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PagedContentLoadingState {
  PagedContentLoadingFailureState? get failureState =>
      throw _privateConstructorUsedError;
  GetPosts get query => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PagedContentLoadingStateCopyWith<PagedContentLoadingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagedContentLoadingStateCopyWith<$Res> {
  factory $PagedContentLoadingStateCopyWith(PagedContentLoadingState value,
          $Res Function(PagedContentLoadingState) then) =
      _$PagedContentLoadingStateCopyWithImpl<$Res, PagedContentLoadingState>;
  @useResult
  $Res call({PagedContentLoadingFailureState? failureState, GetPosts query});

  $PagedContentLoadingFailureStateCopyWith<$Res>? get failureState;
  $GetPostsCopyWith<$Res> get query;
}

/// @nodoc
class _$PagedContentLoadingStateCopyWithImpl<$Res,
        $Val extends PagedContentLoadingState>
    implements $PagedContentLoadingStateCopyWith<$Res> {
  _$PagedContentLoadingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failureState = freezed,
    Object? query = null,
  }) {
    return _then(_value.copyWith(
      failureState: freezed == failureState
          ? _value.failureState
          : failureState // ignore: cast_nullable_to_non_nullable
              as PagedContentLoadingFailureState?,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as GetPosts,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PagedContentLoadingFailureStateCopyWith<$Res>? get failureState {
    if (_value.failureState == null) {
      return null;
    }

    return $PagedContentLoadingFailureStateCopyWith<$Res>(_value.failureState!,
        (value) {
      return _then(_value.copyWith(failureState: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GetPostsCopyWith<$Res> get query {
    return $GetPostsCopyWith<$Res>(_value.query, (value) {
      return _then(_value.copyWith(query: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PagedContentLoadingStateImplCopyWith<$Res>
    implements $PagedContentLoadingStateCopyWith<$Res> {
  factory _$$PagedContentLoadingStateImplCopyWith(
          _$PagedContentLoadingStateImpl value,
          $Res Function(_$PagedContentLoadingStateImpl) then) =
      __$$PagedContentLoadingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PagedContentLoadingFailureState? failureState, GetPosts query});

  @override
  $PagedContentLoadingFailureStateCopyWith<$Res>? get failureState;
  @override
  $GetPostsCopyWith<$Res> get query;
}

/// @nodoc
class __$$PagedContentLoadingStateImplCopyWithImpl<$Res>
    extends _$PagedContentLoadingStateCopyWithImpl<$Res,
        _$PagedContentLoadingStateImpl>
    implements _$$PagedContentLoadingStateImplCopyWith<$Res> {
  __$$PagedContentLoadingStateImplCopyWithImpl(
      _$PagedContentLoadingStateImpl _value,
      $Res Function(_$PagedContentLoadingStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failureState = freezed,
    Object? query = null,
  }) {
    return _then(_$PagedContentLoadingStateImpl(
      failureState: freezed == failureState
          ? _value.failureState
          : failureState // ignore: cast_nullable_to_non_nullable
              as PagedContentLoadingFailureState?,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as GetPosts,
    ));
  }
}

/// @nodoc

class _$PagedContentLoadingStateImpl extends _PagedContentLoadingState {
  const _$PagedContentLoadingStateImpl({this.failureState, required this.query})
      : super._();

  @override
  final PagedContentLoadingFailureState? failureState;
  @override
  final GetPosts query;

  @override
  String toString() {
    return 'PagedContentLoadingState(failureState: $failureState, query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PagedContentLoadingStateImpl &&
            (identical(other.failureState, failureState) ||
                other.failureState == failureState) &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failureState, query);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PagedContentLoadingStateImplCopyWith<_$PagedContentLoadingStateImpl>
      get copyWith => __$$PagedContentLoadingStateImplCopyWithImpl<
          _$PagedContentLoadingStateImpl>(this, _$identity);
}

abstract class _PagedContentLoadingState extends PagedContentLoadingState {
  const factory _PagedContentLoadingState(
      {final PagedContentLoadingFailureState? failureState,
      required final GetPosts query}) = _$PagedContentLoadingStateImpl;
  const _PagedContentLoadingState._() : super._();

  @override
  PagedContentLoadingFailureState? get failureState;
  @override
  GetPosts get query;
  @override
  @JsonKey(ignore: true)
  _$$PagedContentLoadingStateImplCopyWith<_$PagedContentLoadingStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PagedContentLoadingFailureState {
  String get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PagedContentLoadingFailureStateCopyWith<PagedContentLoadingFailureState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagedContentLoadingFailureStateCopyWith<$Res> {
  factory $PagedContentLoadingFailureStateCopyWith(
          PagedContentLoadingFailureState value,
          $Res Function(PagedContentLoadingFailureState) then) =
      _$PagedContentLoadingFailureStateCopyWithImpl<$Res,
          PagedContentLoadingFailureState>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$PagedContentLoadingFailureStateCopyWithImpl<$Res,
        $Val extends PagedContentLoadingFailureState>
    implements $PagedContentLoadingFailureStateCopyWith<$Res> {
  _$PagedContentLoadingFailureStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PagedContentLoadingFailureStateImplCopyWith<$Res>
    implements $PagedContentLoadingFailureStateCopyWith<$Res> {
  factory _$$PagedContentLoadingFailureStateImplCopyWith(
          _$PagedContentLoadingFailureStateImpl value,
          $Res Function(_$PagedContentLoadingFailureStateImpl) then) =
      __$$PagedContentLoadingFailureStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PagedContentLoadingFailureStateImplCopyWithImpl<$Res>
    extends _$PagedContentLoadingFailureStateCopyWithImpl<$Res,
        _$PagedContentLoadingFailureStateImpl>
    implements _$$PagedContentLoadingFailureStateImplCopyWith<$Res> {
  __$$PagedContentLoadingFailureStateImplCopyWithImpl(
      _$PagedContentLoadingFailureStateImpl _value,
      $Res Function(_$PagedContentLoadingFailureStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$PagedContentLoadingFailureStateImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PagedContentLoadingFailureStateImpl
    implements _PagedContentLoadingFailureState {
  const _$PagedContentLoadingFailureStateImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'PagedContentLoadingFailureState(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PagedContentLoadingFailureStateImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PagedContentLoadingFailureStateImplCopyWith<
          _$PagedContentLoadingFailureStateImpl>
      get copyWith => __$$PagedContentLoadingFailureStateImplCopyWithImpl<
          _$PagedContentLoadingFailureStateImpl>(this, _$identity);
}

abstract class _PagedContentLoadingFailureState
    implements PagedContentLoadingFailureState {
  const factory _PagedContentLoadingFailureState(
      {required final String message}) = _$PagedContentLoadingFailureStateImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$PagedContentLoadingFailureStateImplCopyWith<
          _$PagedContentLoadingFailureStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PagedContentLoadedState {
  List<PostView> get content => throw _privateConstructorUsedError;
  int get loadedPage => throw _privateConstructorUsedError;
  GetPosts get query => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PagedContentLoadedStateCopyWith<PagedContentLoadedState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagedContentLoadedStateCopyWith<$Res> {
  factory $PagedContentLoadedStateCopyWith(PagedContentLoadedState value,
          $Res Function(PagedContentLoadedState) then) =
      _$PagedContentLoadedStateCopyWithImpl<$Res, PagedContentLoadedState>;
  @useResult
  $Res call({List<PostView> content, int loadedPage, GetPosts query});

  $GetPostsCopyWith<$Res> get query;
}

/// @nodoc
class _$PagedContentLoadedStateCopyWithImpl<$Res,
        $Val extends PagedContentLoadedState>
    implements $PagedContentLoadedStateCopyWith<$Res> {
  _$PagedContentLoadedStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? loadedPage = null,
    Object? query = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as List<PostView>,
      loadedPage: null == loadedPage
          ? _value.loadedPage
          : loadedPage // ignore: cast_nullable_to_non_nullable
              as int,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as GetPosts,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GetPostsCopyWith<$Res> get query {
    return $GetPostsCopyWith<$Res>(_value.query, (value) {
      return _then(_value.copyWith(query: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PagedContentLoadedStateImplCopyWith<$Res>
    implements $PagedContentLoadedStateCopyWith<$Res> {
  factory _$$PagedContentLoadedStateImplCopyWith(
          _$PagedContentLoadedStateImpl value,
          $Res Function(_$PagedContentLoadedStateImpl) then) =
      __$$PagedContentLoadedStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PostView> content, int loadedPage, GetPosts query});

  @override
  $GetPostsCopyWith<$Res> get query;
}

/// @nodoc
class __$$PagedContentLoadedStateImplCopyWithImpl<$Res>
    extends _$PagedContentLoadedStateCopyWithImpl<$Res,
        _$PagedContentLoadedStateImpl>
    implements _$$PagedContentLoadedStateImplCopyWith<$Res> {
  __$$PagedContentLoadedStateImplCopyWithImpl(
      _$PagedContentLoadedStateImpl _value,
      $Res Function(_$PagedContentLoadedStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? loadedPage = null,
    Object? query = null,
  }) {
    return _then(_$PagedContentLoadedStateImpl(
      content: null == content
          ? _value._content
          : content // ignore: cast_nullable_to_non_nullable
              as List<PostView>,
      loadedPage: null == loadedPage
          ? _value.loadedPage
          : loadedPage // ignore: cast_nullable_to_non_nullable
              as int,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as GetPosts,
    ));
  }
}

/// @nodoc

class _$PagedContentLoadedStateImpl implements _PagedContentLoadedState {
  const _$PagedContentLoadedStateImpl(
      {required final List<PostView> content,
      required this.loadedPage,
      required this.query})
      : _content = content;

  final List<PostView> _content;
  @override
  List<PostView> get content {
    if (_content is EqualUnmodifiableListView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_content);
  }

  @override
  final int loadedPage;
  @override
  final GetPosts query;

  @override
  String toString() {
    return 'PagedContentLoadedState(content: $content, loadedPage: $loadedPage, query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PagedContentLoadedStateImpl &&
            const DeepCollectionEquality().equals(other._content, _content) &&
            (identical(other.loadedPage, loadedPage) ||
                other.loadedPage == loadedPage) &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_content), loadedPage, query);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PagedContentLoadedStateImplCopyWith<_$PagedContentLoadedStateImpl>
      get copyWith => __$$PagedContentLoadedStateImplCopyWithImpl<
          _$PagedContentLoadedStateImpl>(this, _$identity);
}

abstract class _PagedContentLoadedState implements PagedContentLoadedState {
  const factory _PagedContentLoadedState(
      {required final List<PostView> content,
      required final int loadedPage,
      required final GetPosts query}) = _$PagedContentLoadedStateImpl;

  @override
  List<PostView> get content;
  @override
  int get loadedPage;
  @override
  GetPosts get query;
  @override
  @JsonKey(ignore: true)
  _$$PagedContentLoadedStateImplCopyWith<_$PagedContentLoadedStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

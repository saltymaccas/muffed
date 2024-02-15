// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeTabViewModel<T> {
  List<T> get items => throw _privateConstructorUsedError;
  int get pagesLoaded => throw _privateConstructorUsedError;
  bool get endReached => throw _privateConstructorUsedError;
  HomeTabViewStatus get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  LemmySortType? get loadedSortType => throw _privateConstructorUsedError;
  ContentType? get loadedContentType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeTabViewModelCopyWith<T, HomeTabViewModel<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeTabViewModelCopyWith<T, $Res> {
  factory $HomeTabViewModelCopyWith(
          HomeTabViewModel<T> value, $Res Function(HomeTabViewModel<T>) then) =
      _$HomeTabViewModelCopyWithImpl<T, $Res, HomeTabViewModel<T>>;
  @useResult
  $Res call(
      {List<T> items,
      int pagesLoaded,
      bool endReached,
      HomeTabViewStatus status,
      String? errorMessage,
      LemmySortType? loadedSortType,
      ContentType? loadedContentType});
}

/// @nodoc
class _$HomeTabViewModelCopyWithImpl<T, $Res, $Val extends HomeTabViewModel<T>>
    implements $HomeTabViewModelCopyWith<T, $Res> {
  _$HomeTabViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? pagesLoaded = null,
    Object? endReached = null,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? loadedSortType = freezed,
    Object? loadedContentType = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      pagesLoaded: null == pagesLoaded
          ? _value.pagesLoaded
          : pagesLoaded // ignore: cast_nullable_to_non_nullable
              as int,
      endReached: null == endReached
          ? _value.endReached
          : endReached // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as HomeTabViewStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      loadedSortType: freezed == loadedSortType
          ? _value.loadedSortType
          : loadedSortType // ignore: cast_nullable_to_non_nullable
              as LemmySortType?,
      loadedContentType: freezed == loadedContentType
          ? _value.loadedContentType
          : loadedContentType // ignore: cast_nullable_to_non_nullable
              as ContentType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeTabViewModelImplCopyWith<T, $Res>
    implements $HomeTabViewModelCopyWith<T, $Res> {
  factory _$$HomeTabViewModelImplCopyWith(_$HomeTabViewModelImpl<T> value,
          $Res Function(_$HomeTabViewModelImpl<T>) then) =
      __$$HomeTabViewModelImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {List<T> items,
      int pagesLoaded,
      bool endReached,
      HomeTabViewStatus status,
      String? errorMessage,
      LemmySortType? loadedSortType,
      ContentType? loadedContentType});
}

/// @nodoc
class __$$HomeTabViewModelImplCopyWithImpl<T, $Res>
    extends _$HomeTabViewModelCopyWithImpl<T, $Res, _$HomeTabViewModelImpl<T>>
    implements _$$HomeTabViewModelImplCopyWith<T, $Res> {
  __$$HomeTabViewModelImplCopyWithImpl(_$HomeTabViewModelImpl<T> _value,
      $Res Function(_$HomeTabViewModelImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? pagesLoaded = null,
    Object? endReached = null,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? loadedSortType = freezed,
    Object? loadedContentType = freezed,
  }) {
    return _then(_$HomeTabViewModelImpl<T>(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      pagesLoaded: null == pagesLoaded
          ? _value.pagesLoaded
          : pagesLoaded // ignore: cast_nullable_to_non_nullable
              as int,
      endReached: null == endReached
          ? _value.endReached
          : endReached // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as HomeTabViewStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      loadedSortType: freezed == loadedSortType
          ? _value.loadedSortType
          : loadedSortType // ignore: cast_nullable_to_non_nullable
              as LemmySortType?,
      loadedContentType: freezed == loadedContentType
          ? _value.loadedContentType
          : loadedContentType // ignore: cast_nullable_to_non_nullable
              as ContentType?,
    ));
  }
}

/// @nodoc

class _$HomeTabViewModelImpl<T> implements _HomeTabViewModel<T> {
  const _$HomeTabViewModelImpl(
      {required final List<T> items,
      required this.pagesLoaded,
      required this.endReached,
      required this.status,
      this.errorMessage,
      this.loadedSortType,
      this.loadedContentType})
      : _items = items;

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int pagesLoaded;
  @override
  final bool endReached;
  @override
  final HomeTabViewStatus status;
  @override
  final String? errorMessage;
  @override
  final LemmySortType? loadedSortType;
  @override
  final ContentType? loadedContentType;

  @override
  String toString() {
    return 'HomeTabViewModel<$T>(items: $items, pagesLoaded: $pagesLoaded, endReached: $endReached, status: $status, errorMessage: $errorMessage, loadedSortType: $loadedSortType, loadedContentType: $loadedContentType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeTabViewModelImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.pagesLoaded, pagesLoaded) ||
                other.pagesLoaded == pagesLoaded) &&
            (identical(other.endReached, endReached) ||
                other.endReached == endReached) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.loadedSortType, loadedSortType) ||
                other.loadedSortType == loadedSortType) &&
            (identical(other.loadedContentType, loadedContentType) ||
                other.loadedContentType == loadedContentType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      pagesLoaded,
      endReached,
      status,
      errorMessage,
      loadedSortType,
      loadedContentType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeTabViewModelImplCopyWith<T, _$HomeTabViewModelImpl<T>> get copyWith =>
      __$$HomeTabViewModelImplCopyWithImpl<T, _$HomeTabViewModelImpl<T>>(
          this, _$identity);
}

abstract class _HomeTabViewModel<T> implements HomeTabViewModel<T> {
  const factory _HomeTabViewModel(
      {required final List<T> items,
      required final int pagesLoaded,
      required final bool endReached,
      required final HomeTabViewStatus status,
      final String? errorMessage,
      final LemmySortType? loadedSortType,
      final ContentType? loadedContentType}) = _$HomeTabViewModelImpl<T>;

  @override
  List<T> get items;
  @override
  int get pagesLoaded;
  @override
  bool get endReached;
  @override
  HomeTabViewStatus get status;
  @override
  String? get errorMessage;
  @override
  LemmySortType? get loadedSortType;
  @override
  ContentType? get loadedContentType;
  @override
  @JsonKey(ignore: true)
  _$$HomeTabViewModelImplCopyWith<T, _$HomeTabViewModelImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

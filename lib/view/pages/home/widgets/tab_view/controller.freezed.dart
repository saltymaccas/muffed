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
mixin _$HomeTabViewModel {
  int get pagesLoaded => throw _privateConstructorUsedError;
  bool get endReached => throw _privateConstructorUsedError;
  HomeTabViewStatus get status => throw _privateConstructorUsedError;
  List<LemmyPost>? get items => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  LemmySortType? get loadedSortType => throw _privateConstructorUsedError;
  HomeContentType? get loadedContentType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeTabViewModelCopyWith<HomeTabViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeTabViewModelCopyWith<$Res> {
  factory $HomeTabViewModelCopyWith(
          HomeTabViewModel value, $Res Function(HomeTabViewModel) then) =
      _$HomeTabViewModelCopyWithImpl<$Res, HomeTabViewModel>;
  @useResult
  $Res call(
      {int pagesLoaded,
      bool endReached,
      HomeTabViewStatus status,
      List<LemmyPost>? items,
      String? errorMessage,
      LemmySortType? loadedSortType,
      HomeContentType? loadedContentType});
}

/// @nodoc
class _$HomeTabViewModelCopyWithImpl<$Res, $Val extends HomeTabViewModel>
    implements $HomeTabViewModelCopyWith<$Res> {
  _$HomeTabViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pagesLoaded = null,
    Object? endReached = null,
    Object? status = null,
    Object? items = freezed,
    Object? errorMessage = freezed,
    Object? loadedSortType = freezed,
    Object? loadedContentType = freezed,
  }) {
    return _then(_value.copyWith(
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
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<LemmyPost>?,
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
              as HomeContentType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeTabViewModelImplCopyWith<$Res>
    implements $HomeTabViewModelCopyWith<$Res> {
  factory _$$HomeTabViewModelImplCopyWith(_$HomeTabViewModelImpl value,
          $Res Function(_$HomeTabViewModelImpl) then) =
      __$$HomeTabViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int pagesLoaded,
      bool endReached,
      HomeTabViewStatus status,
      List<LemmyPost>? items,
      String? errorMessage,
      LemmySortType? loadedSortType,
      HomeContentType? loadedContentType});
}

/// @nodoc
class __$$HomeTabViewModelImplCopyWithImpl<$Res>
    extends _$HomeTabViewModelCopyWithImpl<$Res, _$HomeTabViewModelImpl>
    implements _$$HomeTabViewModelImplCopyWith<$Res> {
  __$$HomeTabViewModelImplCopyWithImpl(_$HomeTabViewModelImpl _value,
      $Res Function(_$HomeTabViewModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pagesLoaded = null,
    Object? endReached = null,
    Object? status = null,
    Object? items = freezed,
    Object? errorMessage = freezed,
    Object? loadedSortType = freezed,
    Object? loadedContentType = freezed,
  }) {
    return _then(_$HomeTabViewModelImpl(
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
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<LemmyPost>?,
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
              as HomeContentType?,
    ));
  }
}

/// @nodoc

class _$HomeTabViewModelImpl implements _HomeTabViewModel {
  const _$HomeTabViewModelImpl(
      {required this.pagesLoaded,
      required this.endReached,
      required this.status,
      final List<LemmyPost>? items,
      this.errorMessage,
      this.loadedSortType,
      this.loadedContentType})
      : _items = items;

  @override
  final int pagesLoaded;
  @override
  final bool endReached;
  @override
  final HomeTabViewStatus status;
  final List<LemmyPost>? _items;
  @override
  List<LemmyPost>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? errorMessage;
  @override
  final LemmySortType? loadedSortType;
  @override
  final HomeContentType? loadedContentType;

  @override
  String toString() {
    return 'HomeTabViewModel(pagesLoaded: $pagesLoaded, endReached: $endReached, status: $status, items: $items, errorMessage: $errorMessage, loadedSortType: $loadedSortType, loadedContentType: $loadedContentType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeTabViewModelImpl &&
            (identical(other.pagesLoaded, pagesLoaded) ||
                other.pagesLoaded == pagesLoaded) &&
            (identical(other.endReached, endReached) ||
                other.endReached == endReached) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
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
      pagesLoaded,
      endReached,
      status,
      const DeepCollectionEquality().hash(_items),
      errorMessage,
      loadedSortType,
      loadedContentType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeTabViewModelImplCopyWith<_$HomeTabViewModelImpl> get copyWith =>
      __$$HomeTabViewModelImplCopyWithImpl<_$HomeTabViewModelImpl>(
          this, _$identity);
}

abstract class _HomeTabViewModel implements HomeTabViewModel {
  const factory _HomeTabViewModel(
      {required final int pagesLoaded,
      required final bool endReached,
      required final HomeTabViewStatus status,
      final List<LemmyPost>? items,
      final String? errorMessage,
      final LemmySortType? loadedSortType,
      final HomeContentType? loadedContentType}) = _$HomeTabViewModelImpl;

  @override
  int get pagesLoaded;
  @override
  bool get endReached;
  @override
  HomeTabViewStatus get status;
  @override
  List<LemmyPost>? get items;
  @override
  String? get errorMessage;
  @override
  LemmySortType? get loadedSortType;
  @override
  HomeContentType? get loadedContentType;
  @override
  @JsonKey(ignore: true)
  _$$HomeTabViewModelImplCopyWith<_$HomeTabViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

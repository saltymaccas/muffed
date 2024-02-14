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
mixin _$SearchModel {
  List<Object> get items => throw _privateConstructorUsedError;
  SearchStatus get status => throw _privateConstructorUsedError;
  int get pagesLoaded => throw _privateConstructorUsedError;
  bool get allPagesLoaded => throw _privateConstructorUsedError;
  LemmySortType? get loadedSortType => throw _privateConstructorUsedError;
  String? get loadedQuery => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SearchModelCopyWith<SearchModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchModelCopyWith<$Res> {
  factory $SearchModelCopyWith(
          SearchModel value, $Res Function(SearchModel) then) =
      _$SearchModelCopyWithImpl<$Res, SearchModel>;
  @useResult
  $Res call(
      {List<Object> items,
      SearchStatus status,
      int pagesLoaded,
      bool allPagesLoaded,
      LemmySortType? loadedSortType,
      String? loadedQuery,
      String? errorMessage});
}

/// @nodoc
class _$SearchModelCopyWithImpl<$Res, $Val extends SearchModel>
    implements $SearchModelCopyWith<$Res> {
  _$SearchModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? status = null,
    Object? pagesLoaded = null,
    Object? allPagesLoaded = null,
    Object? loadedSortType = freezed,
    Object? loadedQuery = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Object>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SearchStatus,
      pagesLoaded: null == pagesLoaded
          ? _value.pagesLoaded
          : pagesLoaded // ignore: cast_nullable_to_non_nullable
              as int,
      allPagesLoaded: null == allPagesLoaded
          ? _value.allPagesLoaded
          : allPagesLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      loadedSortType: freezed == loadedSortType
          ? _value.loadedSortType
          : loadedSortType // ignore: cast_nullable_to_non_nullable
              as LemmySortType?,
      loadedQuery: freezed == loadedQuery
          ? _value.loadedQuery
          : loadedQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchModelImplCopyWith<$Res>
    implements $SearchModelCopyWith<$Res> {
  factory _$$SearchModelImplCopyWith(
          _$SearchModelImpl value, $Res Function(_$SearchModelImpl) then) =
      __$$SearchModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Object> items,
      SearchStatus status,
      int pagesLoaded,
      bool allPagesLoaded,
      LemmySortType? loadedSortType,
      String? loadedQuery,
      String? errorMessage});
}

/// @nodoc
class __$$SearchModelImplCopyWithImpl<$Res>
    extends _$SearchModelCopyWithImpl<$Res, _$SearchModelImpl>
    implements _$$SearchModelImplCopyWith<$Res> {
  __$$SearchModelImplCopyWithImpl(
      _$SearchModelImpl _value, $Res Function(_$SearchModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? status = null,
    Object? pagesLoaded = null,
    Object? allPagesLoaded = null,
    Object? loadedSortType = freezed,
    Object? loadedQuery = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$SearchModelImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Object>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SearchStatus,
      pagesLoaded: null == pagesLoaded
          ? _value.pagesLoaded
          : pagesLoaded // ignore: cast_nullable_to_non_nullable
              as int,
      allPagesLoaded: null == allPagesLoaded
          ? _value.allPagesLoaded
          : allPagesLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      loadedSortType: freezed == loadedSortType
          ? _value.loadedSortType
          : loadedSortType // ignore: cast_nullable_to_non_nullable
              as LemmySortType?,
      loadedQuery: freezed == loadedQuery
          ? _value.loadedQuery
          : loadedQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SearchModelImpl implements _SearchModel {
  const _$SearchModelImpl(
      {required final List<Object> items,
      required this.status,
      required this.pagesLoaded,
      required this.allPagesLoaded,
      this.loadedSortType,
      this.loadedQuery,
      this.errorMessage})
      : _items = items;

  final List<Object> _items;
  @override
  List<Object> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final SearchStatus status;
  @override
  final int pagesLoaded;
  @override
  final bool allPagesLoaded;
  @override
  final LemmySortType? loadedSortType;
  @override
  final String? loadedQuery;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'SearchModel(items: $items, status: $status, pagesLoaded: $pagesLoaded, allPagesLoaded: $allPagesLoaded, loadedSortType: $loadedSortType, loadedQuery: $loadedQuery, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchModelImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.pagesLoaded, pagesLoaded) ||
                other.pagesLoaded == pagesLoaded) &&
            (identical(other.allPagesLoaded, allPagesLoaded) ||
                other.allPagesLoaded == allPagesLoaded) &&
            (identical(other.loadedSortType, loadedSortType) ||
                other.loadedSortType == loadedSortType) &&
            (identical(other.loadedQuery, loadedQuery) ||
                other.loadedQuery == loadedQuery) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      status,
      pagesLoaded,
      allPagesLoaded,
      loadedSortType,
      loadedQuery,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchModelImplCopyWith<_$SearchModelImpl> get copyWith =>
      __$$SearchModelImplCopyWithImpl<_$SearchModelImpl>(this, _$identity);
}

abstract class _SearchModel implements SearchModel {
  const factory _SearchModel(
      {required final List<Object> items,
      required final SearchStatus status,
      required final int pagesLoaded,
      required final bool allPagesLoaded,
      final LemmySortType? loadedSortType,
      final String? loadedQuery,
      final String? errorMessage}) = _$SearchModelImpl;

  @override
  List<Object> get items;
  @override
  SearchStatus get status;
  @override
  int get pagesLoaded;
  @override
  bool get allPagesLoaded;
  @override
  LemmySortType? get loadedSortType;
  @override
  String? get loadedQuery;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$SearchModelImplCopyWith<_$SearchModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

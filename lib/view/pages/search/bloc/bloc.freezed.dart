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
mixin _$SearchState {
  SearchStatus get status => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  LemmySortType get selectedSortType => throw _privateConstructorUsedError;
  LemmySearchType get searchType => throw _privateConstructorUsedError;
  int get pagesLoaded => throw _privateConstructorUsedError;
  List<LemmyPost>? get posts => throw _privateConstructorUsedError;
  List<LemmyComment>? get comments => throw _privateConstructorUsedError;
  List<LemmyCommunity>? get communities => throw _privateConstructorUsedError;
  List<LemmyPerson>? get users => throw _privateConstructorUsedError;
  LemmySortType? get loadedSortType => throw _privateConstructorUsedError;
  String? get loadedSearchQuery => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  int? get communityId => throw _privateConstructorUsedError;
  String? get communityName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SearchStateCopyWith<SearchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchStateCopyWith<$Res> {
  factory $SearchStateCopyWith(
          SearchState value, $Res Function(SearchState) then) =
      _$SearchStateCopyWithImpl<$Res, SearchState>;
  @useResult
  $Res call(
      {SearchStatus status,
      String searchQuery,
      LemmySortType selectedSortType,
      LemmySearchType searchType,
      int pagesLoaded,
      List<LemmyPost>? posts,
      List<LemmyComment>? comments,
      List<LemmyCommunity>? communities,
      List<LemmyPerson>? users,
      LemmySortType? loadedSortType,
      String? loadedSearchQuery,
      String? errorMessage,
      int? communityId,
      String? communityName});
}

/// @nodoc
class _$SearchStateCopyWithImpl<$Res, $Val extends SearchState>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? searchQuery = null,
    Object? selectedSortType = null,
    Object? searchType = null,
    Object? pagesLoaded = null,
    Object? posts = freezed,
    Object? comments = freezed,
    Object? communities = freezed,
    Object? users = freezed,
    Object? loadedSortType = freezed,
    Object? loadedSearchQuery = freezed,
    Object? errorMessage = freezed,
    Object? communityId = freezed,
    Object? communityName = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SearchStatus,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      selectedSortType: null == selectedSortType
          ? _value.selectedSortType
          : selectedSortType // ignore: cast_nullable_to_non_nullable
              as LemmySortType,
      searchType: null == searchType
          ? _value.searchType
          : searchType // ignore: cast_nullable_to_non_nullable
              as LemmySearchType,
      pagesLoaded: null == pagesLoaded
          ? _value.pagesLoaded
          : pagesLoaded // ignore: cast_nullable_to_non_nullable
              as int,
      posts: freezed == posts
          ? _value.posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<LemmyPost>?,
      comments: freezed == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<LemmyComment>?,
      communities: freezed == communities
          ? _value.communities
          : communities // ignore: cast_nullable_to_non_nullable
              as List<LemmyCommunity>?,
      users: freezed == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<LemmyPerson>?,
      loadedSortType: freezed == loadedSortType
          ? _value.loadedSortType
          : loadedSortType // ignore: cast_nullable_to_non_nullable
              as LemmySortType?,
      loadedSearchQuery: freezed == loadedSearchQuery
          ? _value.loadedSearchQuery
          : loadedSearchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      communityId: freezed == communityId
          ? _value.communityId
          : communityId // ignore: cast_nullable_to_non_nullable
              as int?,
      communityName: freezed == communityName
          ? _value.communityName
          : communityName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchStateImplCopyWith<$Res>
    implements $SearchStateCopyWith<$Res> {
  factory _$$SearchStateImplCopyWith(
          _$SearchStateImpl value, $Res Function(_$SearchStateImpl) then) =
      __$$SearchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SearchStatus status,
      String searchQuery,
      LemmySortType selectedSortType,
      LemmySearchType searchType,
      int pagesLoaded,
      List<LemmyPost>? posts,
      List<LemmyComment>? comments,
      List<LemmyCommunity>? communities,
      List<LemmyPerson>? users,
      LemmySortType? loadedSortType,
      String? loadedSearchQuery,
      String? errorMessage,
      int? communityId,
      String? communityName});
}

/// @nodoc
class __$$SearchStateImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchStateImpl>
    implements _$$SearchStateImplCopyWith<$Res> {
  __$$SearchStateImplCopyWithImpl(
      _$SearchStateImpl _value, $Res Function(_$SearchStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? searchQuery = null,
    Object? selectedSortType = null,
    Object? searchType = null,
    Object? pagesLoaded = null,
    Object? posts = freezed,
    Object? comments = freezed,
    Object? communities = freezed,
    Object? users = freezed,
    Object? loadedSortType = freezed,
    Object? loadedSearchQuery = freezed,
    Object? errorMessage = freezed,
    Object? communityId = freezed,
    Object? communityName = freezed,
  }) {
    return _then(_$SearchStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SearchStatus,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      selectedSortType: null == selectedSortType
          ? _value.selectedSortType
          : selectedSortType // ignore: cast_nullable_to_non_nullable
              as LemmySortType,
      searchType: null == searchType
          ? _value.searchType
          : searchType // ignore: cast_nullable_to_non_nullable
              as LemmySearchType,
      pagesLoaded: null == pagesLoaded
          ? _value.pagesLoaded
          : pagesLoaded // ignore: cast_nullable_to_non_nullable
              as int,
      posts: freezed == posts
          ? _value._posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<LemmyPost>?,
      comments: freezed == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<LemmyComment>?,
      communities: freezed == communities
          ? _value._communities
          : communities // ignore: cast_nullable_to_non_nullable
              as List<LemmyCommunity>?,
      users: freezed == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<LemmyPerson>?,
      loadedSortType: freezed == loadedSortType
          ? _value.loadedSortType
          : loadedSortType // ignore: cast_nullable_to_non_nullable
              as LemmySortType?,
      loadedSearchQuery: freezed == loadedSearchQuery
          ? _value.loadedSearchQuery
          : loadedSearchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      communityId: freezed == communityId
          ? _value.communityId
          : communityId // ignore: cast_nullable_to_non_nullable
              as int?,
      communityName: freezed == communityName
          ? _value.communityName
          : communityName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SearchStateImpl implements _SearchState {
  const _$SearchStateImpl(
      {required this.status,
      required this.searchQuery,
      required this.selectedSortType,
      required this.searchType,
      required this.pagesLoaded,
      final List<LemmyPost>? posts,
      final List<LemmyComment>? comments,
      final List<LemmyCommunity>? communities,
      final List<LemmyPerson>? users,
      this.loadedSortType,
      this.loadedSearchQuery,
      this.errorMessage,
      this.communityId,
      this.communityName})
      : _posts = posts,
        _comments = comments,
        _communities = communities,
        _users = users;

  @override
  final SearchStatus status;
  @override
  final String searchQuery;
  @override
  final LemmySortType selectedSortType;
  @override
  final LemmySearchType searchType;
  @override
  final int pagesLoaded;
  final List<LemmyPost>? _posts;
  @override
  List<LemmyPost>? get posts {
    final value = _posts;
    if (value == null) return null;
    if (_posts is EqualUnmodifiableListView) return _posts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<LemmyComment>? _comments;
  @override
  List<LemmyComment>? get comments {
    final value = _comments;
    if (value == null) return null;
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<LemmyCommunity>? _communities;
  @override
  List<LemmyCommunity>? get communities {
    final value = _communities;
    if (value == null) return null;
    if (_communities is EqualUnmodifiableListView) return _communities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<LemmyPerson>? _users;
  @override
  List<LemmyPerson>? get users {
    final value = _users;
    if (value == null) return null;
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final LemmySortType? loadedSortType;
  @override
  final String? loadedSearchQuery;
  @override
  final String? errorMessage;
  @override
  final int? communityId;
  @override
  final String? communityName;

  @override
  String toString() {
    return 'SearchState(status: $status, searchQuery: $searchQuery, selectedSortType: $selectedSortType, searchType: $searchType, pagesLoaded: $pagesLoaded, posts: $posts, comments: $comments, communities: $communities, users: $users, loadedSortType: $loadedSortType, loadedSearchQuery: $loadedSearchQuery, errorMessage: $errorMessage, communityId: $communityId, communityName: $communityName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.selectedSortType, selectedSortType) ||
                other.selectedSortType == selectedSortType) &&
            (identical(other.searchType, searchType) ||
                other.searchType == searchType) &&
            (identical(other.pagesLoaded, pagesLoaded) ||
                other.pagesLoaded == pagesLoaded) &&
            const DeepCollectionEquality().equals(other._posts, _posts) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            const DeepCollectionEquality()
                .equals(other._communities, _communities) &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.loadedSortType, loadedSortType) ||
                other.loadedSortType == loadedSortType) &&
            (identical(other.loadedSearchQuery, loadedSearchQuery) ||
                other.loadedSearchQuery == loadedSearchQuery) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.communityId, communityId) ||
                other.communityId == communityId) &&
            (identical(other.communityName, communityName) ||
                other.communityName == communityName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      searchQuery,
      selectedSortType,
      searchType,
      pagesLoaded,
      const DeepCollectionEquality().hash(_posts),
      const DeepCollectionEquality().hash(_comments),
      const DeepCollectionEquality().hash(_communities),
      const DeepCollectionEquality().hash(_users),
      loadedSortType,
      loadedSearchQuery,
      errorMessage,
      communityId,
      communityName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchStateImplCopyWith<_$SearchStateImpl> get copyWith =>
      __$$SearchStateImplCopyWithImpl<_$SearchStateImpl>(this, _$identity);
}

abstract class _SearchState implements SearchState {
  const factory _SearchState(
      {required final SearchStatus status,
      required final String searchQuery,
      required final LemmySortType selectedSortType,
      required final LemmySearchType searchType,
      required final int pagesLoaded,
      final List<LemmyPost>? posts,
      final List<LemmyComment>? comments,
      final List<LemmyCommunity>? communities,
      final List<LemmyPerson>? users,
      final LemmySortType? loadedSortType,
      final String? loadedSearchQuery,
      final String? errorMessage,
      final int? communityId,
      final String? communityName}) = _$SearchStateImpl;

  @override
  SearchStatus get status;
  @override
  String get searchQuery;
  @override
  LemmySortType get selectedSortType;
  @override
  LemmySearchType get searchType;
  @override
  int get pagesLoaded;
  @override
  List<LemmyPost>? get posts;
  @override
  List<LemmyComment>? get comments;
  @override
  List<LemmyCommunity>? get communities;
  @override
  List<LemmyPerson>? get users;
  @override
  LemmySortType? get loadedSortType;
  @override
  String? get loadedSearchQuery;
  @override
  String? get errorMessage;
  @override
  int? get communityId;
  @override
  String? get communityName;
  @override
  @JsonKey(ignore: true)
  _$$SearchStateImplCopyWith<_$SearchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

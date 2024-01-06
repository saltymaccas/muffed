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
mixin _$CommunityScreenState {
// state
  /// The status of [GetCommunityResponse]
  CommunityStatus get communityStatus => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  MException? get exception =>
      throw _privateConstructorUsedError; // GetCommunityResponse
  CommunityView? get communityView => throw _privateConstructorUsedError;
  Site? get site => throw _privateConstructorUsedError;
  List<CommunityModeratorView>? get moderators =>
      throw _privateConstructorUsedError;
  List<int>? get discussionLanguages => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CommunityScreenStateCopyWith<CommunityScreenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityScreenStateCopyWith<$Res> {
  factory $CommunityScreenStateCopyWith(CommunityScreenState value,
          $Res Function(CommunityScreenState) then) =
      _$CommunityScreenStateCopyWithImpl<$Res, CommunityScreenState>;
  @useResult
  $Res call(
      {CommunityStatus communityStatus,
      bool isLoading,
      MException? exception,
      CommunityView? communityView,
      Site? site,
      List<CommunityModeratorView>? moderators,
      List<int>? discussionLanguages});

  $CommunityViewCopyWith<$Res>? get communityView;
  $SiteCopyWith<$Res>? get site;
}

/// @nodoc
class _$CommunityScreenStateCopyWithImpl<$Res,
        $Val extends CommunityScreenState>
    implements $CommunityScreenStateCopyWith<$Res> {
  _$CommunityScreenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? communityStatus = null,
    Object? isLoading = null,
    Object? exception = freezed,
    Object? communityView = freezed,
    Object? site = freezed,
    Object? moderators = freezed,
    Object? discussionLanguages = freezed,
  }) {
    return _then(_value.copyWith(
      communityStatus: null == communityStatus
          ? _value.communityStatus
          : communityStatus // ignore: cast_nullable_to_non_nullable
              as CommunityStatus,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      exception: freezed == exception
          ? _value.exception
          : exception // ignore: cast_nullable_to_non_nullable
              as MException?,
      communityView: freezed == communityView
          ? _value.communityView
          : communityView // ignore: cast_nullable_to_non_nullable
              as CommunityView?,
      site: freezed == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as Site?,
      moderators: freezed == moderators
          ? _value.moderators
          : moderators // ignore: cast_nullable_to_non_nullable
              as List<CommunityModeratorView>?,
      discussionLanguages: freezed == discussionLanguages
          ? _value.discussionLanguages
          : discussionLanguages // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CommunityViewCopyWith<$Res>? get communityView {
    if (_value.communityView == null) {
      return null;
    }

    return $CommunityViewCopyWith<$Res>(_value.communityView!, (value) {
      return _then(_value.copyWith(communityView: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SiteCopyWith<$Res>? get site {
    if (_value.site == null) {
      return null;
    }

    return $SiteCopyWith<$Res>(_value.site!, (value) {
      return _then(_value.copyWith(site: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommunityScreenStateImplCopyWith<$Res>
    implements $CommunityScreenStateCopyWith<$Res> {
  factory _$$CommunityScreenStateImplCopyWith(_$CommunityScreenStateImpl value,
          $Res Function(_$CommunityScreenStateImpl) then) =
      __$$CommunityScreenStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CommunityStatus communityStatus,
      bool isLoading,
      MException? exception,
      CommunityView? communityView,
      Site? site,
      List<CommunityModeratorView>? moderators,
      List<int>? discussionLanguages});

  @override
  $CommunityViewCopyWith<$Res>? get communityView;
  @override
  $SiteCopyWith<$Res>? get site;
}

/// @nodoc
class __$$CommunityScreenStateImplCopyWithImpl<$Res>
    extends _$CommunityScreenStateCopyWithImpl<$Res, _$CommunityScreenStateImpl>
    implements _$$CommunityScreenStateImplCopyWith<$Res> {
  __$$CommunityScreenStateImplCopyWithImpl(_$CommunityScreenStateImpl _value,
      $Res Function(_$CommunityScreenStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? communityStatus = null,
    Object? isLoading = null,
    Object? exception = freezed,
    Object? communityView = freezed,
    Object? site = freezed,
    Object? moderators = freezed,
    Object? discussionLanguages = freezed,
  }) {
    return _then(_$CommunityScreenStateImpl(
      communityStatus: null == communityStatus
          ? _value.communityStatus
          : communityStatus // ignore: cast_nullable_to_non_nullable
              as CommunityStatus,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      exception: freezed == exception
          ? _value.exception
          : exception // ignore: cast_nullable_to_non_nullable
              as MException?,
      communityView: freezed == communityView
          ? _value.communityView
          : communityView // ignore: cast_nullable_to_non_nullable
              as CommunityView?,
      site: freezed == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as Site?,
      moderators: freezed == moderators
          ? _value._moderators
          : moderators // ignore: cast_nullable_to_non_nullable
              as List<CommunityModeratorView>?,
      discussionLanguages: freezed == discussionLanguages
          ? _value._discussionLanguages
          : discussionLanguages // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }
}

/// @nodoc

class _$CommunityScreenStateImpl implements _CommunityScreenState {
  const _$CommunityScreenStateImpl(
      {required this.communityStatus,
      required this.isLoading,
      this.exception,
      this.communityView,
      this.site,
      final List<CommunityModeratorView>? moderators,
      final List<int>? discussionLanguages})
      : _moderators = moderators,
        _discussionLanguages = discussionLanguages;

// state
  /// The status of [GetCommunityResponse]
  @override
  final CommunityStatus communityStatus;
  @override
  final bool isLoading;
  @override
  final MException? exception;
// GetCommunityResponse
  @override
  final CommunityView? communityView;
  @override
  final Site? site;
  final List<CommunityModeratorView>? _moderators;
  @override
  List<CommunityModeratorView>? get moderators {
    final value = _moderators;
    if (value == null) return null;
    if (_moderators is EqualUnmodifiableListView) return _moderators;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<int>? _discussionLanguages;
  @override
  List<int>? get discussionLanguages {
    final value = _discussionLanguages;
    if (value == null) return null;
    if (_discussionLanguages is EqualUnmodifiableListView)
      return _discussionLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CommunityScreenState(communityStatus: $communityStatus, isLoading: $isLoading, exception: $exception, communityView: $communityView, site: $site, moderators: $moderators, discussionLanguages: $discussionLanguages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityScreenStateImpl &&
            (identical(other.communityStatus, communityStatus) ||
                other.communityStatus == communityStatus) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.exception, exception) ||
                other.exception == exception) &&
            (identical(other.communityView, communityView) ||
                other.communityView == communityView) &&
            (identical(other.site, site) || other.site == site) &&
            const DeepCollectionEquality()
                .equals(other._moderators, _moderators) &&
            const DeepCollectionEquality()
                .equals(other._discussionLanguages, _discussionLanguages));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      communityStatus,
      isLoading,
      exception,
      communityView,
      site,
      const DeepCollectionEquality().hash(_moderators),
      const DeepCollectionEquality().hash(_discussionLanguages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityScreenStateImplCopyWith<_$CommunityScreenStateImpl>
      get copyWith =>
          __$$CommunityScreenStateImplCopyWithImpl<_$CommunityScreenStateImpl>(
              this, _$identity);
}

abstract class _CommunityScreenState implements CommunityScreenState {
  const factory _CommunityScreenState(
      {required final CommunityStatus communityStatus,
      required final bool isLoading,
      final MException? exception,
      final CommunityView? communityView,
      final Site? site,
      final List<CommunityModeratorView>? moderators,
      final List<int>? discussionLanguages}) = _$CommunityScreenStateImpl;

  @override // state
  /// The status of [GetCommunityResponse]
  CommunityStatus get communityStatus;
  @override
  bool get isLoading;
  @override
  MException? get exception;
  @override // GetCommunityResponse
  CommunityView? get communityView;
  @override
  Site? get site;
  @override
  List<CommunityModeratorView>? get moderators;
  @override
  List<int>? get discussionLanguages;
  @override
  @JsonKey(ignore: true)
  _$$CommunityScreenStateImplCopyWith<_$CommunityScreenStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

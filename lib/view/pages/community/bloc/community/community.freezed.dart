// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CommunityState {
  CommunityStatus get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool? get removed => throw _privateConstructorUsedError;
  DateTime? get published => throw _privateConstructorUsedError;
  DateTime? get updated => throw _privateConstructorUsedError;
  bool? get deleted => throw _privateConstructorUsedError;
  bool? get nsfw => throw _privateConstructorUsedError;
  String? get actorId => throw _privateConstructorUsedError;
  bool? get local => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get banner => throw _privateConstructorUsedError;
  bool? get hidden => throw _privateConstructorUsedError;
  bool? get postingRestrictedToMods => throw _privateConstructorUsedError;
  int? get instanceId => throw _privateConstructorUsedError;
  Site? get site => throw _privateConstructorUsedError;
  List<CommunityModeratorView>? get moderators =>
      throw _privateConstructorUsedError;
  List<int>? get discussionLanguages => throw _privateConstructorUsedError;
  SubscribedType? get subscribedType => throw _privateConstructorUsedError;
  bool? get blocked => throw _privateConstructorUsedError;
  CommunityAggregates? get counts => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CommunityStateCopyWith<CommunityState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityStateCopyWith<$Res> {
  factory $CommunityStateCopyWith(
          CommunityState value, $Res Function(CommunityState) then) =
      _$CommunityStateCopyWithImpl<$Res, CommunityState>;
  @useResult
  $Res call(
      {CommunityStatus status,
      String? errorMessage,
      int? id,
      String? name,
      String? title,
      String? description,
      bool? removed,
      DateTime? published,
      DateTime? updated,
      bool? deleted,
      bool? nsfw,
      String? actorId,
      bool? local,
      String? icon,
      String? banner,
      bool? hidden,
      bool? postingRestrictedToMods,
      int? instanceId,
      Site? site,
      List<CommunityModeratorView>? moderators,
      List<int>? discussionLanguages,
      SubscribedType? subscribedType,
      bool? blocked,
      CommunityAggregates? counts});

  $SiteCopyWith<$Res>? get site;
  $CommunityAggregatesCopyWith<$Res>? get counts;
}

/// @nodoc
class _$CommunityStateCopyWithImpl<$Res, $Val extends CommunityState>
    implements $CommunityStateCopyWith<$Res> {
  _$CommunityStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? id = freezed,
    Object? name = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? removed = freezed,
    Object? published = freezed,
    Object? updated = freezed,
    Object? deleted = freezed,
    Object? nsfw = freezed,
    Object? actorId = freezed,
    Object? local = freezed,
    Object? icon = freezed,
    Object? banner = freezed,
    Object? hidden = freezed,
    Object? postingRestrictedToMods = freezed,
    Object? instanceId = freezed,
    Object? site = freezed,
    Object? moderators = freezed,
    Object? discussionLanguages = freezed,
    Object? subscribedType = freezed,
    Object? blocked = freezed,
    Object? counts = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CommunityStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      removed: freezed == removed
          ? _value.removed
          : removed // ignore: cast_nullable_to_non_nullable
              as bool?,
      published: freezed == published
          ? _value.published
          : published // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deleted: freezed == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      nsfw: freezed == nsfw
          ? _value.nsfw
          : nsfw // ignore: cast_nullable_to_non_nullable
              as bool?,
      actorId: freezed == actorId
          ? _value.actorId
          : actorId // ignore: cast_nullable_to_non_nullable
              as String?,
      local: freezed == local
          ? _value.local
          : local // ignore: cast_nullable_to_non_nullable
              as bool?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String?,
      hidden: freezed == hidden
          ? _value.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool?,
      postingRestrictedToMods: freezed == postingRestrictedToMods
          ? _value.postingRestrictedToMods
          : postingRestrictedToMods // ignore: cast_nullable_to_non_nullable
              as bool?,
      instanceId: freezed == instanceId
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as int?,
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
      subscribedType: freezed == subscribedType
          ? _value.subscribedType
          : subscribedType // ignore: cast_nullable_to_non_nullable
              as SubscribedType?,
      blocked: freezed == blocked
          ? _value.blocked
          : blocked // ignore: cast_nullable_to_non_nullable
              as bool?,
      counts: freezed == counts
          ? _value.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as CommunityAggregates?,
    ) as $Val);
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

  @override
  @pragma('vm:prefer-inline')
  $CommunityAggregatesCopyWith<$Res>? get counts {
    if (_value.counts == null) {
      return null;
    }

    return $CommunityAggregatesCopyWith<$Res>(_value.counts!, (value) {
      return _then(_value.copyWith(counts: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommunityStateImplCopyWith<$Res>
    implements $CommunityStateCopyWith<$Res> {
  factory _$$CommunityStateImplCopyWith(_$CommunityStateImpl value,
          $Res Function(_$CommunityStateImpl) then) =
      __$$CommunityStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CommunityStatus status,
      String? errorMessage,
      int? id,
      String? name,
      String? title,
      String? description,
      bool? removed,
      DateTime? published,
      DateTime? updated,
      bool? deleted,
      bool? nsfw,
      String? actorId,
      bool? local,
      String? icon,
      String? banner,
      bool? hidden,
      bool? postingRestrictedToMods,
      int? instanceId,
      Site? site,
      List<CommunityModeratorView>? moderators,
      List<int>? discussionLanguages,
      SubscribedType? subscribedType,
      bool? blocked,
      CommunityAggregates? counts});

  @override
  $SiteCopyWith<$Res>? get site;
  @override
  $CommunityAggregatesCopyWith<$Res>? get counts;
}

/// @nodoc
class __$$CommunityStateImplCopyWithImpl<$Res>
    extends _$CommunityStateCopyWithImpl<$Res, _$CommunityStateImpl>
    implements _$$CommunityStateImplCopyWith<$Res> {
  __$$CommunityStateImplCopyWithImpl(
      _$CommunityStateImpl _value, $Res Function(_$CommunityStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? id = freezed,
    Object? name = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? removed = freezed,
    Object? published = freezed,
    Object? updated = freezed,
    Object? deleted = freezed,
    Object? nsfw = freezed,
    Object? actorId = freezed,
    Object? local = freezed,
    Object? icon = freezed,
    Object? banner = freezed,
    Object? hidden = freezed,
    Object? postingRestrictedToMods = freezed,
    Object? instanceId = freezed,
    Object? site = freezed,
    Object? moderators = freezed,
    Object? discussionLanguages = freezed,
    Object? subscribedType = freezed,
    Object? blocked = freezed,
    Object? counts = freezed,
  }) {
    return _then(_$CommunityStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CommunityStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      removed: freezed == removed
          ? _value.removed
          : removed // ignore: cast_nullable_to_non_nullable
              as bool?,
      published: freezed == published
          ? _value.published
          : published // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deleted: freezed == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      nsfw: freezed == nsfw
          ? _value.nsfw
          : nsfw // ignore: cast_nullable_to_non_nullable
              as bool?,
      actorId: freezed == actorId
          ? _value.actorId
          : actorId // ignore: cast_nullable_to_non_nullable
              as String?,
      local: freezed == local
          ? _value.local
          : local // ignore: cast_nullable_to_non_nullable
              as bool?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String?,
      hidden: freezed == hidden
          ? _value.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool?,
      postingRestrictedToMods: freezed == postingRestrictedToMods
          ? _value.postingRestrictedToMods
          : postingRestrictedToMods // ignore: cast_nullable_to_non_nullable
              as bool?,
      instanceId: freezed == instanceId
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as int?,
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
      subscribedType: freezed == subscribedType
          ? _value.subscribedType
          : subscribedType // ignore: cast_nullable_to_non_nullable
              as SubscribedType?,
      blocked: freezed == blocked
          ? _value.blocked
          : blocked // ignore: cast_nullable_to_non_nullable
              as bool?,
      counts: freezed == counts
          ? _value.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as CommunityAggregates?,
    ));
  }
}

/// @nodoc

class _$CommunityStateImpl implements _CommunityState {
  const _$CommunityStateImpl(
      {required this.status,
      this.errorMessage,
      this.id,
      this.name,
      this.title,
      this.description,
      this.removed,
      this.published,
      this.updated,
      this.deleted,
      this.nsfw,
      this.actorId,
      this.local,
      this.icon,
      this.banner,
      this.hidden,
      this.postingRestrictedToMods,
      this.instanceId,
      this.site,
      final List<CommunityModeratorView>? moderators,
      final List<int>? discussionLanguages,
      this.subscribedType,
      this.blocked,
      this.counts})
      : _moderators = moderators,
        _discussionLanguages = discussionLanguages;

  @override
  final CommunityStatus status;
  @override
  final String? errorMessage;
  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final bool? removed;
  @override
  final DateTime? published;
  @override
  final DateTime? updated;
  @override
  final bool? deleted;
  @override
  final bool? nsfw;
  @override
  final String? actorId;
  @override
  final bool? local;
  @override
  final String? icon;
  @override
  final String? banner;
  @override
  final bool? hidden;
  @override
  final bool? postingRestrictedToMods;
  @override
  final int? instanceId;
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
  final SubscribedType? subscribedType;
  @override
  final bool? blocked;
  @override
  final CommunityAggregates? counts;

  @override
  String toString() {
    return 'CommunityState(status: $status, errorMessage: $errorMessage, id: $id, name: $name, title: $title, description: $description, removed: $removed, published: $published, updated: $updated, deleted: $deleted, nsfw: $nsfw, actorId: $actorId, local: $local, icon: $icon, banner: $banner, hidden: $hidden, postingRestrictedToMods: $postingRestrictedToMods, instanceId: $instanceId, site: $site, moderators: $moderators, discussionLanguages: $discussionLanguages, subscribedType: $subscribedType, blocked: $blocked, counts: $counts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.removed, removed) || other.removed == removed) &&
            (identical(other.published, published) ||
                other.published == published) &&
            (identical(other.updated, updated) || other.updated == updated) &&
            (identical(other.deleted, deleted) || other.deleted == deleted) &&
            (identical(other.nsfw, nsfw) || other.nsfw == nsfw) &&
            (identical(other.actorId, actorId) || other.actorId == actorId) &&
            (identical(other.local, local) || other.local == local) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.banner, banner) || other.banner == banner) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(
                    other.postingRestrictedToMods, postingRestrictedToMods) ||
                other.postingRestrictedToMods == postingRestrictedToMods) &&
            (identical(other.instanceId, instanceId) ||
                other.instanceId == instanceId) &&
            (identical(other.site, site) || other.site == site) &&
            const DeepCollectionEquality()
                .equals(other._moderators, _moderators) &&
            const DeepCollectionEquality()
                .equals(other._discussionLanguages, _discussionLanguages) &&
            (identical(other.subscribedType, subscribedType) ||
                other.subscribedType == subscribedType) &&
            (identical(other.blocked, blocked) || other.blocked == blocked) &&
            (identical(other.counts, counts) || other.counts == counts));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        status,
        errorMessage,
        id,
        name,
        title,
        description,
        removed,
        published,
        updated,
        deleted,
        nsfw,
        actorId,
        local,
        icon,
        banner,
        hidden,
        postingRestrictedToMods,
        instanceId,
        site,
        const DeepCollectionEquality().hash(_moderators),
        const DeepCollectionEquality().hash(_discussionLanguages),
        subscribedType,
        blocked,
        counts
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityStateImplCopyWith<_$CommunityStateImpl> get copyWith =>
      __$$CommunityStateImplCopyWithImpl<_$CommunityStateImpl>(
          this, _$identity);
}

abstract class _CommunityState implements CommunityState {
  const factory _CommunityState(
      {required final CommunityStatus status,
      final String? errorMessage,
      final int? id,
      final String? name,
      final String? title,
      final String? description,
      final bool? removed,
      final DateTime? published,
      final DateTime? updated,
      final bool? deleted,
      final bool? nsfw,
      final String? actorId,
      final bool? local,
      final String? icon,
      final String? banner,
      final bool? hidden,
      final bool? postingRestrictedToMods,
      final int? instanceId,
      final Site? site,
      final List<CommunityModeratorView>? moderators,
      final List<int>? discussionLanguages,
      final SubscribedType? subscribedType,
      final bool? blocked,
      final CommunityAggregates? counts}) = _$CommunityStateImpl;

  @override
  CommunityStatus get status;
  @override
  String? get errorMessage;
  @override
  int? get id;
  @override
  String? get name;
  @override
  String? get title;
  @override
  String? get description;
  @override
  bool? get removed;
  @override
  DateTime? get published;
  @override
  DateTime? get updated;
  @override
  bool? get deleted;
  @override
  bool? get nsfw;
  @override
  String? get actorId;
  @override
  bool? get local;
  @override
  String? get icon;
  @override
  String? get banner;
  @override
  bool? get hidden;
  @override
  bool? get postingRestrictedToMods;
  @override
  int? get instanceId;
  @override
  Site? get site;
  @override
  List<CommunityModeratorView>? get moderators;
  @override
  List<int>? get discussionLanguages;
  @override
  SubscribedType? get subscribedType;
  @override
  bool? get blocked;
  @override
  CommunityAggregates? get counts;
  @override
  @JsonKey(ignore: true)
  _$$CommunityStateImplCopyWith<_$CommunityStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

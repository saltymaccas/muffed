part of 'bloc.dart';

@freezed
class LemmyKeychainState with _$LemmyKeychainState {
  const factory LemmyKeychainState({
    required LemmyKey activeKey,
    required List<LemmyKey> keys,
  }) = _LemmyKeychainState;

  factory LemmyKeychainState.fromJson(Map<String, Object?> json) =>
      _$LemmyKeychainStateFromJson(json);

  const LemmyKeychainState._();

  bool get isAuthenticated => activeKey.authToken != null;
}

@freezed
class LemmyKey with _$LemmyKey {
  const factory LemmyKey({
    required String instanceAddress,
    String? authToken,
    @_GetSiteResponseConverter() GetSiteResponse? site,
  }) = _LemmyKey;

  factory LemmyKey.fromJson(Map<String, Object?> json) =>
      _$LemmyKeyFromJson(json);
}

class _GetSiteResponseConverter
    implements JsonConverter<GetSiteResponse, Map<String, Object?>> {
  const _GetSiteResponseConverter();
  @override
  Map<String, Object?> toJson(GetSiteResponse value) => value.toJson();

  @override
  GetSiteResponse fromJson(Map<String, Object?> json) =>
      GetSiteResponse.fromJson(json);
}

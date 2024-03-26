part of 'bloc.dart';

@freezed
class LemmyKeychainState with _$LemmyKeychainState {
  const factory LemmyKeychainState({
    required int activeKeyIndex,
    required List<LemmyKey> keys,
  }) = _LemmyKeychainState;

  factory LemmyKeychainState.fromJson(Map<String, Object?> json) =>
      _$LemmyKeychainStateFromJson(json);

  const LemmyKeychainState._();

  LemmyKey get activeKey => keys[activeKeyIndex];
  bool get isAuthenticated => activeKey.authToken != null;
}

@freezed
class LemmyKey with _$LemmyKey {
  const factory LemmyKey({
    required String instanceAddress,
    String? authToken,
  }) = _LemmyKey;

  factory LemmyKey.fromJson(Map<String, Object?> json) =>
      _$LemmyKeyFromJson(json);
}

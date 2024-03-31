part of 'bloc.dart';

enum AddKeyStatus { idle, loading, failure, confirmed }

@freezed
class AddKeyState with _$AddKeyState {
  const factory AddKeyState({
    required AddKeyStatus status,
    GetSiteMetadataResponse? site,
    String? errorMessage,
  }) = _AddKeyState;
}

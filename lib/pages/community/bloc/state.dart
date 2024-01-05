part of 'bloc.dart';

enum CommunityStatus { initial, loading, success, failure }

@freezed
class CommunityScreenState with _$CommunityScreenState{
  const factory CommunityScreenState({

  // state
  /// The status of [GetCommunityResponse]
  required CommunityStatus communityStatus,
  required bool isLoading,
  MException? exception,

  // GetCommunityResponse
  CommunityView? communityView,
  Site? site,
  List<CommunityModeratorView>? moderators,
  List<int>? discussionLanguages,

  
  }) = _CommunityScreenState;
}

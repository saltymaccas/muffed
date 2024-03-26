import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';

import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/domain/lemmy/lemmy.dart';

part 'community.freezed.dart';

final _log = Logger('CommunityController');

sealed class CommunityEvent {}

class Initialised extends CommunityEvent {}

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  CommunityBloc({
    required LemmyRepo lemmyRepo,
    int? communityId,
    String? communityName,
    Community? community,
  })  : lem = lemmyRepo,
        super(
          CommunityState(
            status: CommunityStatus.idle,
            id: communityId ?? community?.id,
            name: communityName ?? community?.name,
            title: community?.title,
            description: community?.description,
            removed: community?.removed,
            published: community?.published,
            updated: community?.updated,
            deleted: community?.deleted,
            nsfw: community?.nsfw,
            actorId: community?.actorId,
            local: community?.local,
            icon: community?.icon,
            banner: community?.banner,
            hidden: community?.hidden,
            postingRestrictedToMods: community?.postingRestrictedToMods,
            instanceId: community?.instanceId,
          ),
        ) {
    on<Initialised>(_onInitialised);
  }

  Future<void> _onInitialised(
    Initialised event,
    Emitter<CommunityState> emit,
  ) async {
    await _load(event, emit, id: state.id, name: state.name);
  }

  Future<void> _load(
    CommunityEvent event,
    Emitter<CommunityState> emit, {
    int? id,
    String? name,
  }) async {
    emit(state.copyWith(status: CommunityStatus.loading));

    try {
      final getCommunityResponse = await lem.getCommunity(id: id, name: name);
      final communityView = getCommunityResponse.communityView;
      final community = communityView.community;

      emit(
        state.copyWith(
          status: CommunityStatus.idle,
          id: community.id,
          name: community.name,
          title: community.title,
          description: community.description,
          removed: community.removed,
          published: community.published,
          updated: community.updated,
          deleted: community.deleted,
          nsfw: community.nsfw,
          actorId: community.actorId,
          local: community.local,
          icon: community.icon,
          banner: community.banner,
          hidden: community.hidden,
          postingRestrictedToMods: community.postingRestrictedToMods,
          instanceId: community.instanceId,
          site: getCommunityResponse.site,
          moderators: getCommunityResponse.moderators,
          discussionLanguages: getCommunityResponse.discussionLanguages,
          blocked: communityView.blocked,
          counts: communityView.counts,
        ),
      );
    } catch (e, stackTrace) {
      _log.warning('Failed to load community', e, stackTrace);
      emit(
        state.copyWith(
          status: CommunityStatus.failure,
          errorMessage: toErrorMessage(e),
        ),
      );
    }
  }

  String toErrorMessage(Object err) {
    return 'Error of type ${err.runtimeType} occurred';
  }

  final LemmyRepo lem;
}

enum CommunityStatus { idle, loading, failure }

@freezed
class CommunityState with _$CommunityState {
  const factory CommunityState({
    required CommunityStatus status,
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
    CommunityAggregates? counts,
  }) = _CommunityState;
}

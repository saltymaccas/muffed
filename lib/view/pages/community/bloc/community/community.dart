import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:muffed/domain/lemmy.dart';
import 'package:muffed/domain/lemmy/models.dart';

part 'community.freezed.dart';

final _log = Logger('CommunityController');

sealed class CommunityEvent {}

class Initialised extends CommunityEvent {}

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  CommunityBloc({
    required LemmyRepo lemmyRepo,
    int? communityId,
    this.community,
  })  : communityId = communityId ?? community!.id,
        lem = lemmyRepo,
        super(
          CommunityState(
            status: CommunityStatus.idle,
            community: community,
          ),
        ) {
    on<Initialised>(_onInitialised);
  }

  Future<void> _onInitialised(
    Initialised event,
    Emitter<CommunityState> emit,
  ) async {
    if (state.community != null && state.community!.isFullyLoaded) {
      return;
    } else {
      await _load(event, emit, id: communityId);
    }
  }

  Future<void> _load(
    CommunityEvent event,
    Emitter<CommunityState> emit, {
    required int id,
  }) async {
    emit(state.copyWith(status: CommunityStatus.loading));

    try {
      final community = await lem.getCommunity(id: id);
      emit(
        state.copyWith(
          status: CommunityStatus.idle,
          community: community,
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
  final int communityId;
  final LemmyCommunity? community;
}

enum CommunityStatus { idle, loading, failure }

@freezed
class CommunityState with _$CommunityState {
  const factory CommunityState({
    required CommunityStatus status,
    LemmyCommunity? community,
    String? errorMessage,
  }) = _CommunityState;
}

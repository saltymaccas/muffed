import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('CommunityScreenBloc');

class CommunityScreenBloc
    extends Bloc<CommunityScreenEvent, CommunityScreenState> {
  ///
  CommunityScreenBloc({
    required this.repo,
    this.community,
    String? communityName,
    this.communityId,
  })  : communityName = (communityName != null && communityName.isNotEmpty)
            ? communityName
            : null,
        super(
          CommunityScreenState(
            community: community,
          ),
        ) {
    on<Initialize>((event, emit) async {
      // get community info if none were passed in
      if (state.community == null) {
        emit(
          state.copyWith(
            communityInfoStatus: CommunityStatus.loading,
            fullCommunityInfoStatus: CommunityStatus.loading,
          ),
        );

        try {
          final community = await repo.lemmyRepo
              .getCommunity(id: communityId, name: this.communityName);

          emit(
            state.copyWith(
              community: community,
              communityInfoStatus: CommunityStatus.success,
            ),
          );
        } catch (err) {
          emit(
            state.copyWith(
              communityInfoStatus: CommunityStatus.failure,
              error: err,
            ),
          );
          rethrow;
        }
      } else {
        emit(state.copyWith(communityInfoStatus: CommunityStatus.success));
      }

      // if community is loaded check if it is fully loaded, if not fully load
      // it
      if (state.communityStatus == CommunityStatus.success) {
        if (!state.community!.isFullyLoaded()) {
          emit(
            state.copyWith(fullCommunityInfoStatus: CommunityStatus.loading),
          );

          try {
            final community = await repo.lemmyRepo.getCommunity(
              id: state.community!.id,
              name: state.community!.name,
            );

            emit(
              state.copyWith(
                community: community,
                fullCommunityInfoStatus: CommunityStatus.success,
              ),
            );
          } catch (err) {
            emit(
              state.copyWith(
                fullCommunityInfoStatus: CommunityStatus.failure,
                error: err,
              ),
            );
            rethrow;
          }
        } else {
          emit(
            state.copyWith(fullCommunityInfoStatus: CommunityStatus.success),
          );
        }
      }
    });

    on<SortTypeChanged>((event, emit) async {
      emit(state.copyWith(sortType: event.sortType, isLoading: true));

      try {
        emit(
          state.copyWith(
            isLoading: false,
            loadedSortType: event.sortType,
          ),
        );
      } catch (err) {
        emit(
          state.copyWith(
            error: err,
            isLoading: false,
            sortType: state.loadedSortType,
          ),
        );
      }
    });
    on<ToggledSubscribe>((event, emit) async {
      emit(
        state.copyWith(
          community: state.community!.copyWith(
            subscribed: (state.community!.subscribed ==
                    LemmySubscribedType.notSubscribed)
                ? LemmySubscribedType.pending
                : LemmySubscribedType.notSubscribed,
          ),
        ),
      );
      try {
        final result = await repo.lemmyRepo.followCommunity(
          communityId: state.community!.id,
          follow:
              state.community!.subscribed != LemmySubscribedType.notSubscribed,
        );
        emit(
          state.copyWith(
            community: state.community!.copyWith(subscribed: result),
          ),
        );
      } catch (err) {
        emit(state.copyWith(error: err));
      }
    });
    on<BlockToggled>((event, emit) async {
      if (state.community!.blocked != null) {
        emit(
          state.copyWith(
            community:
                state.community!.copyWith(blocked: !state.community!.blocked!),
          ),
        );
        try {
          final response = await repo.lemmyRepo.BlockCommunity(
            id: state.community!.id,
            block: state.community!.blocked!,
          );
          emit(
            state.copyWith(
              community: state.community!.copyWith(blocked: response),
            ),
          );
        } catch (err) {
          emit(
            state.copyWith(
              community: state.community!
                  .copyWith(blocked: !state.community!.blocked!),
              error: err,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            error: Exception('Tried to toggle block when block = null'),
          ),
        );
        _log.warning('Tried to toggle block when block = null');
      }
    });
  }

  final String? communityName;
  final int? communityId;
  final LemmyCommunity? community;
  final ServerRepo repo;

  @override
  void onChange(Change<CommunityScreenState> change) {
    super.onChange(change);
    _log.fine(change);
  }

  @override
  void onTransition(
    Transition<CommunityScreenEvent, CommunityScreenState> transition,
  ) {
    super.onTransition(transition);
    _log.fine(transition);
  }
}

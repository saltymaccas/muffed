import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/interfaces/lemmy/lemmy.dart';

part 'bloc.freezed.dart';
part 'event.dart';
part 'state.dart';

final _log = Logger('CommunityScreenBloc');

/// Provides logic for displaying a community
class CommunityScreenBloc
    extends Bloc<CommunityScreenEvent, CommunityScreenState> {
  CommunityScreenBloc({
    required this.lemClient,
    CommunityView? communityView,
    String? communityName,
    int? communityId,
  })  : communityName = communityName ?? communityView?.community.name,
        communityId = communityId ?? communityView?.community.id,
        assert(
          communityName != null || communityId != null,
          'No community defined',
        ),
        super(CommunityScreenState(
          communityStatus: CommunityStatus.initial,
          isLoading: false,
          communityView: communityView,
        )) {
    on<InitialiseCommunityScreen>((event, emit) async {
      emit(
        state.copyWith(
          communityStatus: CommunityStatus.loading,
        ),
      );

      try {
        final response = await lemClient.getCommunity(
          id: communityId,
          name: communityName,
        );

        emit(
          state.copyWith(
            communityView: response.communityView,
            discussionLanguages: response.discussionLanguages,
            moderators: response.moderators,
            site: response.site,
            communityStatus: CommunityStatus.success,
          ),
        );
      } catch (exc, stackTrace) {
        final exception = MException(exc, stackTrace)..log(_log);
        emit(
          state.copyWith(
            communityStatus: CommunityStatus.failure,
            exception: exception,
          ),
        );
      }
    });
    on<ToggledSubscribe>((event, emit) async {
      final lastSubscribedType = state.communityView!.subscribed;
      final newSubscribedType = lastSubscribedType == SubscribedType.subscribed
          ? SubscribedType.notSubscribed
          : SubscribedType.pending;
      emit(
        state.copyWith.communityView!(subscribed: newSubscribedType),
      );
      try {
        final response = await lemClient.followCommunity(
          communityId: state.communityView!.community.id,
          follow:
              state.communityView!.subscribed != SubscribedType.notSubscribed,
        );
        emit(
          state.copyWith(
            communityView: response.communityView,
            discussionLanguages: response.discussionLanguages,
          ),
        );
      } catch (exc, stackTrace) {
        final exception = MException(exc, stackTrace)..log(_log);
        emit(
          state.copyWith(
            exception: exception,
            communityView: state.communityView!.copyWith(
              subscribed: lastSubscribedType,
            ),
          ),
        );
      }
    });
    on<BlockToggled>((event, emit) async {
      final lastBlocked = state.communityView!.blocked;
      final newBlocked = !lastBlocked;

      emit(
        state.copyWith.communityView!(blocked: newBlocked),
      );
      try {
        final response = await lemClient.blockCommunity(
          communityId: state.communityView!.community.id,
          block: newBlocked,
        );
        emit(
          state.copyWith(communityView: response.communityView),
        );
      } catch (exc, stackTrace) {
        final exception = MException(exc, stackTrace)..log(_log);
        emit(
          state.copyWith(
            exception: exception,
            communityView: state.communityView!.copyWith(blocked: lastBlocked),
          ),
        );
      }
    });
  }

  /// Used get the community if it is not provided
  final String? communityName;

  /// Used get the community if it is not provided
  final int? communityId;

  final LemmyClient lemClient;
}

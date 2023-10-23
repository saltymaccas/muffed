import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/url.dart';

part 'event.dart';
part 'state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  ///
  CreatePostBloc(
      {required this.communityId, required this.repo, this.communityInfo})
      : super(
          CreatePostState(
            communityId: communityId,
            communityInfo: communityInfo,
            communityInfoStatus: (communityInfo == null)
                ? CommunityInfoStatus.initial
                : CommunityInfoStatus.success,
          ),
        ) {
    on<Initalize>((event, emit) async {
      if (state.communityInfoStatus == CommunityInfoStatus.initial ||
          state.communityInfoStatus == CommunityInfoStatus.failure) {
        emit(state.copyWith(communityInfoStatus: CommunityInfoStatus.loading));

        try {
          final response = await repo.lemmyRepo.getCommunity(id: communityId);

          emit(
            state.copyWith(
              communityInfoStatus: CommunityInfoStatus.success,
              communityInfo: response,
            ),
          );
        } catch (err) {
          emit(
            state.copyWith(
              error: err,
              communityInfoStatus: CommunityInfoStatus.failure,
            ),
          );
        }
      }
    });
    on<PreviewToggled>((event, emit) {
      emit(state.copyWith(isPreviewingBody: !state.isPreviewingBody));
    });
    on<PostSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final response = await repo.lemmyRepo.createPost(
          name: event.title,
          body: event.body,
          url: (event.url == null || event.url == '')
              ? null
              : ensureProtocolSpecified(event.url!),
          communityId: communityId,
        );

        emit(state.copyWith(successfullyPosted: response, isLoading: false));
      } catch (err) {
        emit(state.copyWith(error: err, isLoading: false));
      }
    });
  }

  final LemmyCommunity? communityInfo;
  final int communityId;
  final ServerRepo repo;
}

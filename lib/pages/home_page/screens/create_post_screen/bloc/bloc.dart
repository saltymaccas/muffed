import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/url.dart';

import '../../../../../repo/pictrs/models.dart';

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
    on<ImageToUploadSelected>((event, emit) async {
      final id =
          (state.images.lastKey() == null) ? 0 : state.images.lastKey()! + 1;

      emit(
        state.copyWith(
          images: SplayTreeMap()
            ..addAll(
              {...state.images, id: ImageUploadState(uploadProgress: 0)},
            ),
        ),
      );

      final stream =
          repo.pictrsRepo.uploadImage(filePath: event.filePath, id: id);

      try {
        await for (final data in stream) {
          emit(
            state.copyWith(
              images: SplayTreeMap()..addAll({...state.images, id: data}),
            ),
          );
        }
      } catch (err) {
        emit(
          state.copyWith(
            error: err,
            images: SplayTreeMap()
              ..addAll(state.images)
              ..remove(id),
          ),
        );
      }
    });
    on<UploadedImageRemoved>((event, emit) async {
      final removedImage = state.images[event.id]!;

      emit(
        state.copyWith(
          images: SplayTreeMap()
            ..addAll(state.images)
            ..remove(event.id),
        ),
      );

      try {
        await repo.pictrsRepo.deleteImage(
          removedImage.deleteToken!,
          removedImage.imageName!,
          removedImage.baseUrl!,
        );
      } catch (err) {
        emit(
          state.copyWith(
            error: err,
            images: SplayTreeMap()
              ..addAll({...state.images, event.id: removedImage}),
          ),
        );
      }
    });
  }

  final LemmyCommunity? communityInfo;
  final int communityId;
  final ServerRepo repo;
}

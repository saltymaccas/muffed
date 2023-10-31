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
    on<BodyImageToUploadSelected>((event, emit) async {
      final id = (state.bodyImages.lastKey() == null)
          ? 0
          : state.bodyImages.lastKey()! + 1;

      emit(
        state.copyWith(
          images: SplayTreeMap()
            ..addAll(
              {...state.bodyImages, id: ImageUploadState(uploadProgress: 0)},
            ),
        ),
      );

      final stream =
          repo.pictrsRepo.uploadImage(filePath: event.filePath, id: id);

      try {
        await for (final data in stream) {
          emit(
            state.copyWith(
              images: SplayTreeMap()..addAll({...state.bodyImages, id: data}),
            ),
          );
        }
      } catch (err) {
        emit(
          state.copyWith(
            error: err,
            images: SplayTreeMap()
              ..addAll(state.bodyImages)
              ..remove(id),
          ),
        );
      }
    });
    on<ImageToUploadSelected>((event, emit) async {
      emit(
        state.copyWith(
          image: ImageUploadState(uploadProgress: 0),
        ),
      );

      final stream = repo.pictrsRepo.uploadImage(filePath: event.filePath);

      try {
        await for (final data in stream) {
          emit(
            state.copyWith(
              image: data,
            ),
          );
        }
      } catch (err) {
        emit(
          state.copyWith(
            error: err,
            setImageToNull: true,
          ),
        );
      }
    });
    on<UploadedBodyImageRemoved>((event, emit) async {
      final removedImage = state.bodyImages[event.id]!;

      emit(
        state.copyWith(
          images: SplayTreeMap()
            ..addAll(state.bodyImages)
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
              ..addAll({...state.bodyImages, event.id: removedImage}),
          ),
        );
      }
    });
    on<ImageRemoved>((event, emit) async {
      final removedImage = state.image!;

      emit(
        state.copyWith(
          setImageToNull: true,
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
          ),
        );
      }
    });
    on<UrlAdded>((event, emit) {
      emit(state.copyWith(url: ensureProtocolSpecified(event.url)));
    });
    on<UrlRemoved>((event, emit) {
      emit(state.copyWith(setUrlToNull: true));
    });
  }

  final LemmyCommunity? communityInfo;
  final int communityId;
  final ServerRepo repo;
}

import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/repo/pictrs/models.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/url.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('CreatePostBloc');

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  CreatePostBloc({
    required this.repo,
    int? recipientCommunityId,
    LemmyCommunity? recipientCommunity,
    LemmyPost? postBeingEdited,
  })  : assert(
          recipientCommunity != null || recipientCommunityId != null,
          'no community given',
        ),
        idOfPostBeingEdited = postBeingEdited?.id,
        communityId = recipientCommunityId ?? recipientCommunity!.id,
        super(
          CreatePostState(
            recipientCommunityInfo: recipientCommunity,
            recipientCommunityInfoStatus: (recipientCommunity == null)
                ? CommunityInfoStatus.initial
                : CommunityInfoStatus.success,
          ),
        ) {
    on<Initalize>((event, emit) async {
      if (state.recipientCommunityInfoStatus == CommunityInfoStatus.initial ||
          state.recipientCommunityInfoStatus == CommunityInfoStatus.failure) {
        emit(state.copyWith(
            recipientCommunityInfoStatus: CommunityInfoStatus.loading));

        try {
          final response = await repo.lemmyRepo.getCommunity(id: communityId);

          emit(
            state.copyWith(
              recipientCommunityInfoStatus: CommunityInfoStatus.success,
              recipientCommunityInfo: response,
            ),
          );
        } catch (exc, stackTrace) {
          final exception = MException(exc, stackTrace)..log(_log);
          emit(
            state.copyWith(
              exception: exception,
              recipientCommunityInfoStatus: CommunityInfoStatus.failure,
            ),
          );
        }
      }
    });
    on<PostSubmitted>((event, emit) async {
      emit(state.copyWith(isPosting: true));

      try {
        if (idOfPostBeingEdited != null) {
          final response = await repo.lemmyRepo.editPost(
            id: idOfPostBeingEdited!,
            name: event.title,
            body: event.body,
            url: (state.enteredUrl == null || state.enteredUrl == '')
                ? (state.image == null)
                    ? null
                    : state.image!.baseUrl
                : cleanseUrl(state.enteredUrl!),
          );
          emit(state.copyWith(successfullyPosted: response, isPosting: false));
        } else {
          final response = await repo.lemmyRepo.createPost(
            name: event.title,
            body: event.body,
            communityId: communityId,
            url: (state.enteredUrl == null || state.enteredUrl == '')
                ? (state.image == null)
                    ? null
                    : state.image!.baseUrl
                : cleanseUrl(state.enteredUrl!),
          );
          emit(state.copyWith(successfullyPosted: response, isPosting: false));
        }
      } catch (exc, stackTrace) {
        final exception = MException(exc, stackTrace)..log(_log);
        emit(state.copyWith(exception: exception, isPosting: false));
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
              {
                ...state.bodyImages,
                id: const ImageUploadState(),
              },
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
      } catch (exc, stackTrace) {
        final exception = MException(exc, stackTrace)..log(_log);
        emit(
          state.copyWith(
            exception: exception,
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
          image: const ImageUploadState(),
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
      } catch (exc, stackTrace) {
        final exception = MException(exc, stackTrace)..log(_log);
        emit(
          state.copyWith(
            exception: exception,
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
      } catch (exc, stackTrace) {
        final exception = MException(exc, stackTrace)..log(_log);
        emit(
          state.copyWith(
            exception: exception,
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
      } catch (exc, stackTrace) {
        final exception = MException(exc, stackTrace)..log(_log);
        emit(
          state.copyWith(
            exception: exception,
          ),
        );
      }
    });
    on<UrlAdded>((event, emit) {
      emit(state.copyWith(enteredUrl: event.url));
    });
    on<UrlRemoved>((event, emit) {
      emit(state.copyWith(setEnteredUrlToNull: true));
    });
  }

  final int communityId;

  final ServerRepo repo;

  /// Set this if the user is editing a post rather then creating a new one.
  final int? idOfPostBeingEdited;

  bool get isEditingPost => idOfPostBeingEdited != null;
}

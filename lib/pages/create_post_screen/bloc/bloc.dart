import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/repo/pictrs/models.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/url.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('CreatePostBloc');

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  ///
  CreatePostBloc({
    required this.communityId,
    required this.repo,
    this.initialUrl,
    this.communityInfo,
    this.postBeingEdited,
  }) : super(
          CreatePostState(
            url: initialUrl,
            communityId: communityId,
            communityInfo: communityInfo,
            editingPostId: postBeingEdited?.id,
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
          final response = await repo.lemmyRepo
              .getCommunity(id: communityId ?? postBeingEdited!.communityId);

          emit(
            state.copyWith(
              communityInfoStatus: CommunityInfoStatus.success,
              communityInfo: response,
            ),
          );
        } catch (exc, stackTrace) {
          final exception = MException(exc, stackTrace)..log(_log);
          emit(
            state.copyWith(
              exception: exception,
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
        if (state.communityId != null) {
          final response = await repo.lemmyRepo.createPost(
            name: event.title,
            body: event.body,
            url: (event.url == null || event.url == '')
                ? null
                : cleanseUrl(event.url!),
            communityId: communityId!,
          );
          emit(state.copyWith(successfullyPosted: response, isLoading: false));
        } else if (state.editingPostId != null) {
          final response = await repo.lemmyRepo.editPost(
            id: state.editingPostId!,
            name: event.title,
            body: event.body,
            url: (event.url == null || event.url == '')
                ? null
                : cleanseUrl(event.url!),
          );
          emit(state.copyWith(successfullyPosted: response, isLoading: false));
        }
      } catch (exc, stackTrace) {
        final exception = MException(exc, stackTrace)..log(_log);
        emit(state.copyWith(exception: exception, isLoading: false));
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
      emit(state.copyWith(url: cleanseUrl(event.url)));
    });
    on<UrlRemoved>((event, emit) {
      emit(state.copyWith(setUrlToNull: true));
    });
  }

  /// Only set if user is editing an existing post, should be the url in the
  /// original post
  final String? initialUrl;
  final LemmyPost? postBeingEdited;
  final LemmyCommunity? communityInfo;
  final int? communityId;
  final ServerRepo repo;
}

import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/repo/pictrs/models.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('CreateCommentBloc');

class CreateCommentBloc extends Bloc<CreateCommentEvent, CreateCommentState> {
  ///
  CreateCommentBloc({
    required this.repo,
    required this.onSuccess,
    this.commentBeingEdited,
  }) : super(CreateCommentState(commentBeingEdited: commentBeingEdited)) {
    on<Submitted>((event, emit) async {
      _log.info('Comment submitted');
      if (event.commentContents.isNotEmpty) {
        emit(state.copyWith(isLoading: true));

        try {
          if (state.commentBeingEdited == null) {
            final response = await repo.lemmyRepo.createComment(
              event.commentContents,
              event.postId,
              event.commentId,
            );

            emit(state.copyWith(isLoading: false, successfullyPosted: true));
          } else {
            final response = await repo.lemmyRepo.editComment(
              content: event.commentContents,
              id: state.commentBeingEdited!.id,
            );

            emit(state.copyWith(isLoading: false, successfullyPosted: true));
          }
        } catch (err) {
          emit(state.copyWith(isLoading: false, error: err));
        }
      } else {
        _log.info('Comment submitted with no text');
        emit(state.copyWith(error: 'No text inputted'));
      }
    });
    on<PreviewToggled>((event, emit) {
      emit(state.copyWith(isPreviewing: !state.isPreviewing));
    });
    on<ImageToUploadSelected>((event, emit) async {
      final id =
          (state.images.lastKey() == null) ? 0 : state.images.lastKey()! + 1;

      emit(
        state.copyWith(
          images: SplayTreeMap()
            ..addAll(
              {...state.images, id: const ImageUploadState(uploadProgress: 0)},
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

  final LemmyComment? commentBeingEdited;
  final ServerRepo repo;
  final void Function() onSuccess;
}

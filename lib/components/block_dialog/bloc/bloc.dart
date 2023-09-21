import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';

import '../block_dialog.dart';

part 'event.dart';
part 'state.dart';

class BlockDialogBloc extends Bloc<BlockDialogEvent, BlockDialogState> {
  ///
  BlockDialogBloc({required this.repo, required this.id, required this.type})
      : super(BlockDialogState()) {
    on<InitializeEvent>((event, emit) async {
      emit(state.copyWith(status: BlockDialogStatus.loading));
      try {
        if (type == BlockDialogType.person) {
          final isBlocked = await repo.lemmyRepo.getIsPersonBlocked(id);
          emit(state.copyWith(
              isBlocked: isBlocked, status: BlockDialogStatus.success));
        } else if (type == BlockDialogType.community) {
          final isBlocked = await repo.lemmyRepo.getIsCommunityBlocked(id);
          emit(
            state.copyWith(
              isBlocked: isBlocked,
              status: BlockDialogStatus.success,
            ),
          );
        }
      } catch (err) {
        emit(state.copyWith(status: BlockDialogStatus.failure, error: err));
      }
    });
    on<BlockOrUnblockRequested>((event, emit) async {
      emit(
        state.copyWith(isLoading: true),
      );
      try {
        if (type == BlockDialogType.person) {
          final response = await repo.lemmyRepo.BlockPerson(
            personId: id,
            block: !state.isBlocked!,
          );
          emit(
            state.copyWith(isBlocked: response, isLoading: false),
          );
        } else if (type == BlockDialogType.community) {
          final response = await repo.lemmyRepo.BlockCommunity(
            id: id,
            block: !state.isBlocked!,
          );
          emit(
            state.copyWith(isBlocked: response, isLoading: false),
          );
        }
      } catch (err) {
        emit(state.copyWith(error: err, isLoading: false));
        rethrow;
      }
    }, transformer: droppable());
  }

  final ServerRepo repo;
  final int id;
  final BlockDialogType type;
}

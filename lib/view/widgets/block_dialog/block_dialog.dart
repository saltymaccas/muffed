import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/widgets/block_dialog/bloc/bloc.dart';
import 'package:muffed/view/widgets/error.dart';

enum BlockDialogType { person, community }

class BlockDialog extends StatelessWidget {
  const BlockDialog({
    required this.name,
    required this.id,
    required this.type,
    super.key,
  });

  final int id;
  final BlockDialogType type;
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlockDialogBloc(
        id: id,
        type: type,
        repo: context.read<ServerRepo>(),
      )..add(InitializeEvent()),
      child: BlocBuilder<BlockDialogBloc, BlockDialogState>(
          builder: (context, state) {
        late Widget dialog;

        if (state.status == BlockDialogStatus.loading) {
          dialog = _BlockDialogLoading(
            name: name,
          );
        } else if (state.status == BlockDialogStatus.failure) {
          dialog = _BlockDialogFailure(
            state: state,
          );
        } else if (state.status == BlockDialogStatus.success) {
          dialog = _BlockDialogSuccess(state: state, name: name);

          _BlockDialogSuccess(
            state: state,
            name: name,
          );
        } else {
          dialog = Container();
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: dialog,
        );
      },),
    );
  }
}

class _BlockDialogLoading extends StatelessWidget {
  const _BlockDialogLoading({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const LinearProgressIndicator(),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Cancel'),),
      ],
    );
  }
}

class _BlockDialogFailure extends StatelessWidget {
  const _BlockDialogFailure({required this.state});

  final BlockDialogState state;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: ErrorComponentTransparent(
        error: state.error,
        retryFunction: () {
          context.read<BlockDialogBloc>().add(InitializeEvent());
        },
      ),
    );
  }
}

class _BlockDialogSuccess extends StatelessWidget {
  const _BlockDialogSuccess({
    required this.state,
    required this.name,
  });

  final BlockDialogState state;
  final String name;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          '$name is currently ${state.isBlocked! ? 'blocked' : 'not blocked'}',),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Done'),
        ),
        AnimatedSize(
          curve: Curves.easeInOutCubic,
          duration: const Duration(milliseconds: 200),
          child: TextButton(
            onPressed: () {
              context.read<BlockDialogBloc>().add(BlockOrUnblockRequested());
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
            child: state.isLoading
                ? const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Text((state.isBlocked!) ? 'Unblock' : 'Block'),
          ),
        ),
      ],
    );
  }
}

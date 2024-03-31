import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/lemmy_keychain/bloc.dart';
import 'package:muffed/view/widgets/key_card.dart';

class KeyManager extends StatefulWidget {
  const KeyManager({this.onSwapKeyPressed, super.key});

  final void Function()? onSwapKeyPressed;

  @override
  State<KeyManager> createState() => _KeyManagerState();
}

class _KeyManagerState extends State<KeyManager> {
  late final LemmyKeychainBloc lemmyKeyChainBloc;

  @override
  void initState() {
    super.initState();
    lemmyKeyChainBloc = context.read<LemmyKeychainBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LemmyKeychainBloc, LemmyKeychainState>(
      builder: (context, state) {
        return Column(
          children: [
            KeyCard(
              lemKey: state.activeKey,
            ),
            TextButton(
              onPressed: widget.onSwapKeyPressed,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text('swap key'), Icon(Icons.swap_horiz)],
              ),
            ),
          ],
        );
      },
    );
  }
}

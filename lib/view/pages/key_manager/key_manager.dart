import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/lemmy_keychain/bloc.dart';
import 'package:muffed/view/pages/add_key/add_key.dart';
import 'package:muffed/view/router/router.dart';
import 'package:muffed/view/widgets/key_card.dart';

class KeyManagerPage extends StatefulWidget {
  const KeyManagerPage({super.key});

  @override
  State<KeyManagerPage> createState() => _KeyManagerPageState();
}

class _KeyManagerPageState extends State<KeyManagerPage> {
  late final LemmyKeychainBloc lemmyKeychainBloc;
  late LemmyKey selectedKey;

  @override
  void initState() {
    super.initState();
    lemmyKeychainBloc = context.read<LemmyKeychainBloc>();
    selectedKey = lemmyKeychainBloc.state.activeKey;
  }

  Future<void> onDeletePressed(BuildContext context, int index) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Remove Key?',
        ),
        actions: [
          TextButton(
            child: const Text('cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('remove'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      lemmyKeychainBloc.add(KeyRemoved(index));
    }
  }

  Widget keycardBuilder(
    BuildContext context,
    LemmyKey key,
    int index, {
    required bool isSelected,
  }) {
    return KeyCard(
      slim: true,
      lemKey: key,
      markAsSelected: isSelected,
      onDeletePressed: () => onDeletePressed(context, index),
      onTap: () => onKeyCardTap(key),
    );
  }

  void onKeyCardTap(LemmyKey key) {
    setState(() {
      selectedKey = key;
    });
  }

  void onAddPressed(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (context) => const AddKeyPage(),
        fullscreenDialog: true,
      ),
    );
  }

  void onCancelTap(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onApplyTap(BuildContext context) {
    lemmyKeychainBloc.add(ActiveKeyChanged(selectedKey));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LemmyKeychainBloc, LemmyKeychainState>(
      bloc: lemmyKeychainBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Key manager')),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ...List.generate(
                      state.keys.length,
                      (index) => keycardBuilder(
                        context,
                        state.keys[index],
                        index,
                        isSelected: selectedKey == state.keys[index],
                      ),
                    ),
                    _AddButton(
                      onPressed: () => onAddPressed(context),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(
                      'cancel',
                    ),
                    onPressed: () => onCancelTap(context),
                  ),
                  TextButton(
                    child: Text(
                      'apply',
                    ),
                    onPressed: () => onApplyTap(context),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({this.onPressed, super.key});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 6 / 1,
      child: Card(
          child:
              InkWell(onTap: onPressed, child: Center(child: Icon(Icons.add)))),
    );
  }
}

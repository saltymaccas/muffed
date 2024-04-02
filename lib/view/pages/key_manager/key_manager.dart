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
  late int selectedKeyIndex;

  @override
  void initState() {
    super.initState();
    lemmyKeychainBloc = context.read<LemmyKeychainBloc>();
    selectedKeyIndex = lemmyKeychainBloc.state.activeKeyIndex;
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
      onTap: () => onKeyCardTap(index),
    );
  }

  void onKeyCardTap(int index) {
    setState(() {
      selectedKeyIndex = index;
    });
  }

  void onAddPressed(BuildContext context) {
    MNavigator.of(context)
        .pushPage(MuffedPage(builder: (context) => AddKeyPage()));
  }

  void onCancelTap(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onApplyTap(BuildContext context) {
    lemmyKeychainBloc.add(ActiveKeyChanged(selectedKeyIndex));
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
                        isSelected: selectedKeyIndex == index,
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

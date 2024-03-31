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

  @override
  void initState() {
    super.initState();
    lemmyKeychainBloc = context.read<LemmyKeychainBloc>();
  }

  Widget keycardBuilder(BuildContext context, LemmyKey key) {
    return KeyCard(
      slim: true,
      lemKey: key,
    );
  }

  void onAddPressed(BuildContext context) {
    MNavigator.of(context)
        .pushPage(MuffedPage(builder: (context) => AddKeyPage()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LemmyKeychainBloc, LemmyKeychainState>(
      bloc: lemmyKeychainBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('Key manager')),
          body: Align(
            alignment: Alignment.bottomCenter,
            child: ListView(
              shrinkWrap: true,
              children: [
                ...List.generate(
                  state.keys.length,
                  (index) => keycardBuilder(context, state.keys[index]),
                ),
                _AddButton(
                  onPressed: () => onAddPressed(context),
                ),
              ],
            ),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/lemmy/lemmy.dart';
import 'package:muffed/domain/lemmy_keychain/bloc.dart';
import 'package:muffed/view/pages/add_key/bloc/bloc.dart';

class AddKeyPage extends StatefulWidget {
  const AddKeyPage({super.key});

  @override
  State<AddKeyPage> createState() => _AddKeyPageState();
}

class _AddKeyPageState extends State<AddKeyPage> {
  late final TextEditingController instanceAddressController;
  late final AddKeyBloc addKeyBloc;

  @override
  void initState() {
    super.initState();
    instanceAddressController = TextEditingController();
    addKeyBloc = AddKeyBloc(
      lem: context.read<LemmyRepo>(),
      keychain: context.read<LemmyKeychainBloc>(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    instanceAddressController.dispose();
  }

  void onSubmitPressed(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Key')),
      body: Align(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Instance Address',
                  border: OutlineInputBorder(),
                ),
                controller: instanceAddressController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () => onSubmitPressed(context),
                      child: Text('Submit')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

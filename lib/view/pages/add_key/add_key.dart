import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/lemmy/lemmy.dart';
import 'package:muffed/domain/lemmy_keychain/bloc.dart';
import 'package:muffed/view/pages/add_key/bloc/bloc.dart';
import 'package:muffed/view/widgets/snackbars.dart';

class AddKeyPage extends StatefulWidget {
  const AddKeyPage({super.key});

  @override
  State<AddKeyPage> createState() => _AddKeyPageState();
}

class _AddKeyPageState extends State<AddKeyPage> {
  late final TextEditingController instanceAddressController;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final TextEditingController twoFAController;
  late final AddKeyBloc addKeyBloc;

  bool authenticate = false;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    instanceAddressController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    twoFAController = TextEditingController();
    addKeyBloc = AddKeyBloc(
      lem: context.read<LemmyRepo>(),
      keychain: context.read<LemmyKeychainBloc>(),
    )..stream.listen((event) => addKeyListener(context, event));
  }

  @override
  void dispose() {
    super.dispose();
    instanceAddressController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    twoFAController.dispose();
  }

  void addKeyListener(BuildContext context, AddKeyState event) {
    if (event.status == AddKeyStatus.confirmed) {
      Navigator.of(context).pop();
    }

    if (event.status == AddKeyStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        ErrorSnackBar(
          context: context,
          errorMessage: event.errorMessage,
        ),
      );
    }
  }

  void onAuthenticateChanged(bool? value) {
    if (value != null) {
      setState(() {
        authenticate = value;
      });
    }
  }

  void onSubmitPressed(BuildContext context) {
    addKeyBloc.add(
      Submitted(
        instanceAddress: instanceAddressController.text,
        authenticate: authenticate,
        username: usernameController.text,
        password: passwordController.text,
        twoFA: twoFAController.text,
      ),
    );
  }

  void onObscurePasswordToggled() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddKeyBloc, AddKeyState>(
      bloc: addKeyBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Key'),
            bottom: (state.status == AddKeyStatus.loading)
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(6),
                    child: LinearProgressIndicator(),
                  )
                : null,
          ),
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
                  const SizedBox(
                    height: 8,
                  ),
                  CheckboxListTile(
                    title: const Text('Authenticate'),
                    value: authenticate,
                    onChanged: onAuthenticateChanged,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    enabled: authenticate,
                    decoration: const InputDecoration(
                      labelText: 'username',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    controller: usernameController,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    enabled: authenticate,
                    decoration: InputDecoration(
                      labelText: 'password',
                      border: OutlineInputBorder(),
                      isDense: true,
                      suffix: IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: onObscurePasswordToggled,
                        icon: (obscurePassword)
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                      ),
                    ),
                    obscureText: obscurePassword,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    enabled: authenticate,
                    decoration: const InputDecoration(
                      labelText: '2fa (optional)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    controller: twoFAController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => onSubmitPressed(context),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

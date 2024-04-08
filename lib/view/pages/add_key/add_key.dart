import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class _AddKeyPageState extends State<AddKeyPage> with TickerProviderStateMixin {
  late final TextEditingController instanceAddressController;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final TextEditingController twoFAController;
  late final AddKeyBloc addKeyBloc;

  late final AnimationController authAnimController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: authAnimController,
    curve: Curves.fastOutSlowIn,
  );

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
    authAnimController.dispose();
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
      if (value) {
        authAnimController.forward();
      } else {
        authAnimController.reverse();
      }
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
    final theme = Theme.of(context);
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
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Instance Address',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        hintStyle: theme.textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.w900),
                      ),
                      controller: instanceAddressController,
                      style: theme.textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      CheckboxListTile(
                        title: const Text('Authenticate'),
                        value: authenticate,
                        onChanged: onAuthenticateChanged,
                        contentPadding: const EdgeInsets.only(left: 8),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      SizeTransition(
                        sizeFactor: _animation,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              enabled: authenticate,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                              ),
                              controller: usernameController,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            TextField(
                              enabled: authenticate,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: Align(
                                  heightFactor: 1,
                                  widthFactor: 1,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: onObscurePasswordToggled,
                                    icon: obscurePassword
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off),
                                  ),
                                ),
                              ),
                              obscureText: obscurePassword,
                              controller: passwordController,
                            ),
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: 0.5,
                                child: TextField(
                                  enabled: authenticate,
                                  decoration: const InputDecoration(
                                    labelText: '2fa (optional)',
                                    counterText: '',
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  controller: twoFAController,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () => onSubmitPressed(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.maxFinite, 40),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

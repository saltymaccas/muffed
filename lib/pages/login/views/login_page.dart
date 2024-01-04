import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/local_store/local_store.dart';
import 'package:muffed/models/url.dart';
import 'package:muffed/pages/login/bloc/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/router.dart';

class LoginPage extends MPage<void> {
  LoginPage({this.onSuccessfulLogin});

  final void Function()? onSuccessfulLogin;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginPageBloc(context.read<ServerRepo>(), context.read<LocalStore>()),
      child: _LoginView(
        onSuccessfulLogin: onSuccessfulLogin,
      ),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView({this.onSuccessfulLogin});

  final void Function()? onSuccessfulLogin;

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final serverAddressController = TextEditingController();
  final serverAddressFocusNode = FocusNode();
  final totpController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    serverAddressController.dispose();
    totpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginPageBloc, LoginPageState>(
      listener: (context, state) {
        if (state.successfullyLoggedIn) {
          context.pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 5,
                  child: (state.loading)
                      ? const LinearProgressIndicator()
                      : Container(),
                ),
                Center(
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TypeAheadField(
                          hideOnEmpty: true,
                          focusNode: serverAddressFocusNode,
                          controller: serverAddressController,
                          builder: (context, controller, focusNode) {
                            return TextFormField(
                              controller: serverAddressController,
                              focusNode: focusNode,
                              keyboardType: TextInputType.url,
                              decoration: const InputDecoration(
                                filled: false,
                                border: OutlineInputBorder(),
                                label: Text('Server Address'),
                              ),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter the server address';
                                }
                                if (value != null &&
                                    !HttpUrl.isValidHttpUrl(value)) {
                                  return 'The server address is not valid';
                                }
                                return null;
                              },
                            );
                          },
                          itemBuilder: (context, value) {
                            return ListTile(
                              title: Text(value),
                            );
                          },
                          onSelected: (value) {
                            serverAddressController.text = value;
                          },
                          suggestionsCallback: (search) {
                            if (search.isEmpty) {
                              return List<String>.empty();
                            }
                            return instances
                                .where((element) => element.contains(search))
                                .toList();
                          },
                        ),
                        const Gap(16),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Username or Email'),
                            filled: false,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Please enter your username or email';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          controller: usernameController,
                        ),
                        const Gap(16),
                        TextFormField(
                          autocorrect: false,
                          enableSuggestions: false,
                          obscureText: !state.revealPassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                context
                                    .read<LoginPageBloc>()
                                    .add(RevealPasswordToggled());
                              },
                              icon: (state.revealPassword)
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            filled: false,
                            border: const OutlineInputBorder(),
                            alignLabelWithHint: true,
                            label: const Text('Password'),
                          ),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          controller: passwordController,
                        ),
                        const Gap(16),
                        TextFormField(
                          decoration: const InputDecoration(
                            filled: false,
                            isDense: true,
                            border: OutlineInputBorder(),
                            label: Text('TOTP (Optional)'),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          controller: totpController,
                        ),
                        TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final username = usernameController.text;
                              final password = passwordController.text;
                              final serverAddress =
                                  serverAddressController.text;

                              context.read<LoginPageBloc>().add(
                                    Submitted(
                                      username: username,
                                      password: password,
                                      serverAddress:
                                          HttpUrl.parse(serverAddress),
                                    ),
                                  );
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.exception != null)
                  ExceptionWidget(exception: state.exception!),
              ],
            ),
          ),
        );
      },
    );
  }
}

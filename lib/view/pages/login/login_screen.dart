import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/domain/global_state/bloc.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/pages/login/bloc/bloc.dart';
import 'package:muffed/view/widgets/error.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginPageBloc(context.read<ServerRepo>(), context.read<GlobalBloc>()),
      child: BlocBuilder<LoginPageBloc, LoginPageState>(
        buildWhen: (previous, current) {
          if (previous.copyWith(
                password: '',
                serverAddr: '',
                totp: '',
                usernameOrEmail: '',
              ) !=
              current.copyWith(
                password: '',
                serverAddr: '',
                totp: '',
                usernameOrEmail: '',
              )) {
            return true;
          } else {
            return false;
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
            body: ListView(
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
                        TextField(
                          decoration: const InputDecoration(
                            label: Text('Username or Email'),
                            filled: true,
                          ),
                          onChanged: (value) {
                            context
                                .read<LoginPageBloc>()
                                .add(UserNameOrEmailChanged(value));
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            filled: true,
                            label: Text('TOTP (Optional)'),
                          ),
                          onChanged: (value) {
                            context
                                .read<LoginPageBloc>()
                                .add(TotpChanged(value));
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextField(
                          obscureText: !state.revealPassword,
                          autocorrect: false,
                          enableSuggestions: false,
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
                            filled: true,
                            label: const Text('Password'),
                          ),
                          onChanged: (value) {
                            context
                                .read<LoginPageBloc>()
                                .add(PasswordChanged(value));
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            filled: true,
                            label: Text('Server Address'),
                          ),
                          onChanged: (value) {
                            context
                                .read<LoginPageBloc>()
                                .add(ServerAddressChanged(value));
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<LoginPageBloc>().add(
                              Submitted(() {
                                context.pop();
                              }),
                            );
                          },
                          child: const Text('Login'),
                        ),
                        if (state.errorMessage != null)
                          ErrorComponentTransparent(
                            error: state.errorMessage,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

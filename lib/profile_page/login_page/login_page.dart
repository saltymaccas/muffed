import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/repo/server_repo.dart';
import 'bloc/bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginPageBloc(context.read<ServerRepo>()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                TextField(
                  decoration: InputDecoration(
                      label: Text('Username or Email'), filled: true),
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  decoration:
                  InputDecoration(filled: true, label: Text('TOTP (Optional)')),
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  decoration:
                  InputDecoration(filled: true, label: Text('Password')),
                ),
                SizedBox(
                  height: 16,
                ),
                TextButton(onPressed: () {}, child: Text('Login'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

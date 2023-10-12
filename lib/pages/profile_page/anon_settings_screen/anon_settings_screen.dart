import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/pages/profile_page/anon_settings_screen/bloc/bloc.dart';
import 'package:muffed/repo/server_repo.dart';

class AnonSettingsScreen extends StatelessWidget {
  const AnonSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnonSettingsBloc(repo: context.read<ServerRepo>()),
      child: Scaffold(
        appBar: AppBar(title: Text('Anon Settings')),
        body: Column(
          children: [
            TextField(
              decoration: InputDecoration(label: Text('Home Lemmy server')),
            ),
          ],
        ),
      ),
    );
  }
}

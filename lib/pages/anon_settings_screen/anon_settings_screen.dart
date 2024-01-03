import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/anon_settings_screen/bloc/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/muffed_avatar.dart';

class AnonSettingsScreen extends StatelessWidget {
  const AnonSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textFieldController = TextEditingController(
      text: context.read<GlobalBloc>().state.lemmyDefaultHomeServer,
    );

    return BlocProvider(
      create: (context) => AnonSettingsBloc(
        repo: context.read<ServerRepo>(),
        globalBloc: context.read<GlobalBloc>(),
      ),
      child: BlocBuilder<AnonSettingsBloc, AnonSettingsState>(
        buildWhen: (previous, current) {
          if (previous.copyWith(urlInput: '') !=
              current.copyWith(urlInput: '')) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          Widget? siteAvatar;

          if (state.siteOfInputted != null) {
            if (state.siteOfInputted!.icon != null) {
              siteAvatar = MuffedAvatar(
                url: state.siteOfInputted!.icon,
                identiconID: state.siteOfInputted!.name,
                radius: 100,
              );
            }
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Anon Settings')),
            body: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: siteAvatar,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: textFieldController,
                    onChanged: (text) {
                      context
                          .read<AnonSettingsBloc>()
                          .add(UrlTextFieldChanged(text));
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      label: Text('Home Lemmy server'),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<AnonSettingsBloc>().add(SaveRequested());
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

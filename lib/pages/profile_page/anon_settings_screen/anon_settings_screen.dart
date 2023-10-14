import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/muffed_avatar.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/profile_page/anon_settings_screen/bloc/bloc.dart';
import 'package:muffed/repo/server_repo.dart';

import '../../../components/muffed_page.dart';

class AnonSettingsScreen extends StatelessWidget {
  const AnonSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textFieldController = TextEditingController(
      text: context
          .read<GlobalBloc>()
          .state
          .lemmyDefaultHomeServer,
    );

    return BlocProvider(
      create: (context) =>
          AnonSettingsBloc(
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
                radius: 100,
              );
            }
          }


          return MuffedPage(
            error: state.error,
            isLoading: state.isLoading,
            child: Scaffold(
              appBar: AppBar(title: Text('Anon Settings')),
              body: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: siteAvatar,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
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
                      child: Text('Save'))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

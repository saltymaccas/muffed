import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/widgets/popup_menu/popup_menu.dart';

class DefaultsSettingsPage extends StatelessWidget {
  const DefaultsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Defaults'),
            leading: IconButton(
              onPressed: () {
                // TODO: add navigation
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: ListView(
            children: [
              ListTile(
                title: const Text('Sort Type'),
                trailing: MuffedPopupMenuButton(
                  icon: Text(state.defaultSortType.toString()),
                  items: const [],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

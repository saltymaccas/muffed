import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/local_store/local_store.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/widgets/popup_menu/popup_menu.dart';

class SettingsDefaultsPage extends MPage<void> {
  SettingsDefaultsPage();

  @override
  Widget build(BuildContext context) {
    return const _DefaultsSettingsView();
  }
}

class _DefaultsSettingsView extends StatelessWidget {
  const _DefaultsSettingsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalStore, GlobalState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Defaults'),
            leading: IconButton(
              onPressed: () {
                context.pop();
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

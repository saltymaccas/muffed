import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/settings/settings.dart';
import 'package:muffed/router/router.dart';

class SettingsPage extends MPage<void> {
  const SettingsPage();

  @override
  Widget build(BuildContext context) {
    return const _SettingsView();
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {},
            ),
          ),
          body: ListView(
            children: [
              ListTile(
                title: const Text('User Interface'),
                style: ListTileStyle.drawer,
                visualDensity: VisualDensity.comfortable,
                leading: const Icon(Icons.color_lens),
                subtitle: const Text('Change how Muffed looks'),
                onTap: () {
                  context.push(const SettingsLookPage());
                },
              ),
              ListTile(
                title: const Text('Content Filters'),
                style: ListTileStyle.drawer,
                visualDensity: VisualDensity.comfortable,
                leading: const Icon(Icons.filter_list),
                subtitle: const Text('Filter certain posts'),
                onTap: () {
                  context.push(const SettingsContentFiltersPage());
                },
              ),
              ListTile(
                title: const Text('About Muffed'),
                style: ListTileStyle.drawer,
                visualDensity: VisualDensity.comfortable,
                leading: const Icon(Icons.info),
                onTap: () {
                  context.push(const AboutPage());

                  // showLicensePage(
                  //   context: context,
                  //   applicationName: 'Muffed',
                  //   applicationVersion: '0.6.0+7',
                  //   applicationIcon: Image.asset(
                  //     'assets/icon.png',
                  //     width: 196,
                  //     height: 196,
                  //   ),
                  // );
                },
              ),
              /*ListTile(
                title: Text('Defaults'),
                style: ListTileStyle.drawer,
                visualDensity: VisualDensity.comfortable,
                leading: Icon(Icons.label),
                subtitle: Text('Set default sort'),
                onTap: () {
                  context.push('/profile/settings/defaults');
                },
              ),*/
            ],
          ),
        );
      },
    );
  }
}

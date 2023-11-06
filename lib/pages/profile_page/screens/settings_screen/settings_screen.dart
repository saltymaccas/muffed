import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/global_state/bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return SetPageInfo(
          actions: [],
          indexOfRelevantItem: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: context.pop,
              ),
            ),
            body: ListView(
              children: [
                ListTile(
                  title: Text('User Interface'),
                  style: ListTileStyle.drawer,
                  visualDensity: VisualDensity.comfortable,
                  leading: Icon(Icons.color_lens),
                  subtitle: Text('Change how Muffed looks'),
                  onTap: () {
                    context.push('/profile/settings/look');
                  },
                ),
                ListTile(
                  title: Text('Content Filters'),
                  style: ListTileStyle.drawer,
                  visualDensity: VisualDensity.comfortable,
                  leading: Icon(Icons.filter_list),
                  subtitle: Text('Filter certain posts'),
                  onTap: () {
                    context.push('/profile/settings/contentfilters');
                  },
                ),
                ListTile(
                  title: Text('About Muffed'),
                  style: ListTileStyle.drawer,
                  visualDensity: VisualDensity.comfortable,
                  leading: Icon(Icons.info),
                  onTap: () {
                    context.push('/profile/settings/about');

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
          ),
        );
      },
    );
  }
}

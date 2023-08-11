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
                  title: Text('Theme Management'),
                  style: ListTileStyle.drawer,
                  visualDensity: VisualDensity.comfortable,
                  leading: Icon(Icons.color_lens),
                  subtitle: Text('Change app colors'),
                  onTap: () {
                    context.push('/profile/settings/look');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

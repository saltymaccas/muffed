import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SettingsThemePage extends StatelessWidget {
  const SettingsThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Theme'),
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Theme Mode',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              RadioListTile<ThemeMode>(
                title: Text('System'),
                value: ThemeMode.system,
                groupValue: context.read<GlobalBloc>().state.themeMode,
                onChanged: (ThemeMode? themeMode) {
                  context
                      .read<GlobalBloc>()
                      .add(ThemeModeChanged(ThemeMode.system));
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text('Light'),
                value: ThemeMode.light,
                groupValue: context.read<GlobalBloc>().state.themeMode,
                onChanged: (ThemeMode? themeMode) {
                  context
                      .read<GlobalBloc>()
                      .add(ThemeModeChanged(ThemeMode.light));
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text('Dark'),
                value: ThemeMode.dark,
                groupValue: context.read<GlobalBloc>().state.themeMode,
                onChanged: (ThemeMode? themeMode) {
                  context
                      .read<GlobalBloc>()
                      .add(ThemeModeChanged(ThemeMode.dark));
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Color',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SwitchListTile(
                title: Text('Auto set color scheme'),
                value: context.read<GlobalBloc>().state.useDynamicColorScheme,
                onChanged: (bool value) {
                  context
                      .read<GlobalBloc>()
                      .add(UseDynamicColorSchemeChanged(value));
                },
              ),
              if (!context.read<GlobalBloc>().state.useDynamicColorScheme)
                ListTile(
                  title: Text('Seed Color'),
                  leading: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: context.read<GlobalBloc>().state.seedColor,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: IntrinsicHeight(
                            child: MaterialPicker(
                              pickerColor:
                                  context.read<GlobalBloc>().state.seedColor,
                              onColorChanged: (color) {
                                context
                                    .read<GlobalBloc>()
                                    .add(SeedColorChanged(color));
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

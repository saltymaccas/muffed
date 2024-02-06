import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/global_state/bloc.dart';

class SettingsLookPage extends StatelessWidget {
  const SettingsLookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('User Interface'),
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
                title: const Text('System'),
                value: ThemeMode.system,
                groupValue: context.read<GlobalBloc>().state.themeMode,
                onChanged: (ThemeMode? themeMode) {
                  context.read<GlobalBloc>().add(
                        SettingChanged(state.copyWith(themeMode: themeMode)),
                      );
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Light'),
                value: ThemeMode.light,
                groupValue: context.read<GlobalBloc>().state.themeMode,
                onChanged: (ThemeMode? themeMode) {
                  context.read<GlobalBloc>().add(
                        SettingChanged(state.copyWith(themeMode: themeMode)),
                      );
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Dark'),
                value: ThemeMode.dark,
                groupValue: context.read<GlobalBloc>().state.themeMode,
                onChanged: (ThemeMode? themeMode) {
                  context.read<GlobalBloc>().add(
                        SettingChanged(state.copyWith(themeMode: themeMode)),
                      );
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
                title: const Text('Auto set color scheme'),
                value: context.read<GlobalBloc>().state.useDynamicColorScheme,
                onChanged: (bool value) {
                  context.read<GlobalBloc>().add(
                        SettingChanged(
                          state.copyWith(useDynamicColorScheme: value),
                        ),
                      );
                },
              ),
              if (!context.read<GlobalBloc>().state.useDynamicColorScheme)
                ListTile(
                  title: const Text('Seed Color'),
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
                                context.read<GlobalBloc>().add(
                                      SettingChanged(
                                        state.copyWith(seedColor: color),
                                      ),
                                    );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Text Sizes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Title Size',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    ToggleButtons(
                      borderWidth: 2,
                      borderRadius: BorderRadius.circular(8),
                      isSelected: [
                        (state.titleTextScaleFactor == 0.9),
                        (state.titleTextScaleFactor == 1),
                        (state.titleTextScaleFactor == 1.1),
                        (state.titleTextScaleFactor == 1.3),
                      ],
                      onPressed: (index) {
                        final List<double> values = [0.9, 1, 1.1, 1.3];

                        context.read<GlobalBloc>().add(
                              SettingChanged(
                                state.copyWith(
                                  titleTextScaleFactor: values[index],
                                ),
                              ),
                            );
                      },
                      children: const [
                        Text('0.9x'),
                        Text('1x'),
                        Text('1.1x'),
                        Text('1.3x'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Label Size',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    ToggleButtons(
                      borderWidth: 2,
                      borderRadius: BorderRadius.circular(8),
                      isSelected: [
                        (state.labelTextScaleFactor == 0.9),
                        (state.labelTextScaleFactor == 1),
                        (state.labelTextScaleFactor == 1.1),
                        (state.labelTextScaleFactor == 1.3),
                      ],
                      onPressed: (index) {
                        final List<double> values = [0.9, 1, 1.1, 1.3];

                        context.read<GlobalBloc>().add(
                              SettingChanged(
                                state.copyWith(
                                  labelTextScaleFactor: values[index],
                                ),
                              ),
                            );
                      },
                      children: const [
                        Text('0.9x'),
                        Text('1x'),
                        Text('1.1x'),
                        Text('1.3x'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Body Size',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    ToggleButtons(
                      borderWidth: 2,
                      borderRadius: BorderRadius.circular(8),
                      isSelected: [
                        (state.bodyTextScaleFactor == 0.9),
                        (state.bodyTextScaleFactor == 1),
                        (state.bodyTextScaleFactor == 1.1),
                        (state.bodyTextScaleFactor == 1.3),
                      ],
                      onPressed: (index) {
                        final List<double> values = [0.9, 1, 1.1, 1.3];

                        context.read<GlobalBloc>().add(
                              SettingChanged(
                                state.copyWith(
                                  bodyTextScaleFactor: values[index],
                                ),
                              ),
                            );
                      },
                      children: const [
                        Text('0.9x'),
                        Text('1x'),
                        Text('1.1x'),
                        Text('1.3x'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

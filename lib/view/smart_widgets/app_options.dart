import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/local_options/bloc.dart';
import 'package:muffed/view/pages/profile/models/colorscheme_options.dart';
import 'package:muffed/view/smart_widgets/color_scheme_dialog.dart';
import 'package:muffed/view/smart_widgets/theme_mode_dialog.dart';

class AppOptions extends StatefulWidget {
  const AppOptions({super.key});

  @override
  State<AppOptions> createState() => _AppOptionsState();
}

class _AppOptionsState extends State<AppOptions> {
  late final LocalOptionsBloc localOptionsBloc;

  @override
  void initState() {
    super.initState();
    localOptionsBloc = context.read<LocalOptionsBloc>();
  }

  void onThemeModeTap(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => ThemeModeDialog(
        setThemeMode: (themeMode) =>
            localOptionsBloc.add(ThemeModeChanged(themeMode)),
        initialThemeMode: localOptionsBloc.state.themeMode,
      ),
    );
  }

  void onColorSchemeTap(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => ColorSchemeDialog(
        initalColorScheme:
            ColorSchemeOptions.fromLocalOptionsState(localOptionsBloc.state),
        onChanged: (o) {
          final s = o.toLocalOptionsState();
          localOptionsBloc.add(
            ColorSchemeChanged(
              useSystemColorScheme: s.$1,
              seedColorScheme: s.$2,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<LocalOptionsBloc, LocalOptionsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: _OptionCard(
                    title: const Text('Theme Mode'),
                    subtitle: Text(state.themeMode.toHumaneString()),
                    onTap: () => onThemeModeTap(context),
                  ),
                ),
                Flexible(
                  child: _OptionCard(
                    title: const Text('Color Scheme'),
                    subtitle: Text(
                      ColorSchemeOptions.fromLocalOptionsState(state)
                          .humaneString,
                    ),
                    onTap: () => onColorSchemeTap(context),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.title,
    this.subtitle,
    this.onTap,
    super.key,
  });

  final Widget title;
  final Widget? subtitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleTextStyle = theme.textTheme.titleMedium!;
    final subtitleTextStyle = theme.textTheme.labelMedium!;
    return Card(
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: double.maxFinite,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Align(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(style: titleTextStyle, child: title),
                  if (subtitle != null)
                    DefaultTextStyle(
                      style: subtitleTextStyle,
                      child: subtitle!,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

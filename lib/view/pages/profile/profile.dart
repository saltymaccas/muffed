import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/local_options/bloc.dart';
import 'package:muffed/view/pages/profile/models/colorscheme_options.dart';
import 'package:muffed/view/pages/profile/widget/color_scheme_dialog.dart';
import 'package:muffed/view/pages/profile/widget/theme_mode_dialog.dart';
import 'package:muffed/view/router/models/page.dart';

class ProfilePage extends MPage<void> {
  ProfilePage();

  @override
  Widget build(BuildContext context) {
    return const ProfilePageView();
  }
}

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
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
    return Scaffold(
      body: BlocBuilder<LocalOptionsBloc, LocalOptionsState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  child: Text('App Options', style: theme.textTheme.titleLarge),
                ),
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
            ),
          );
        },
      ),
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

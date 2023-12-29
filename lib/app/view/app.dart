import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/theme/theme.dart';

/// Initialises app providers
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GlobalBloc()),
      ],
      child: Builder(
        builder: (context) {
          return RepositoryProvider(
            create: (context) => ServerRepo(context.read<GlobalBloc>()),
            child: const _AppTheme(),
          );
        },
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView(this.lightTheme, this.darkTheme, this.themeMode);

  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routerConfig,
      title: 'Muffed',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
    );
  }
}

/// Sets up the app theme
class _AppTheme extends StatelessWidget {
  const _AppTheme();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      buildWhen: (previous, current) {
        if (previous.useDynamicColorScheme != current.useDynamicColorScheme) {
          return true;
        }
        if (previous.seedColor != current.seedColor) {
          return true;
        }
        if (previous.themeMode != current.themeMode) {
          return true;
        }
        if (previous.titleTextScaleFactor != current.titleTextScaleFactor) {
          return true;
        }
        if (previous.labelTextScaleFactor != current.labelTextScaleFactor) {
          return true;
        }
        if (previous.bodyTextScaleFactor != current.bodyTextScaleFactor) {
          return true;
        }
        if (previous.useDynamicColorScheme != current.useDynamicColorScheme) {
          return true;
        }
        if (previous.seedColor != current.seedColor) {
          return true;
        }
        if (previous.themeMode != current.themeMode) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            final textTheme = Theme.of(context).textTheme;
            // Changes the sizes of the text to match the user preferences
            final adjustedTextTheme = textTheme.copyWith(
              titleLarge: textTheme.titleLarge!.apply(
                fontSizeFactor: state.titleTextScaleFactor,
              ),
              titleMedium: textTheme.titleMedium!.apply(
                fontSizeFactor: state.titleTextScaleFactor,
              ),
              titleSmall: textTheme.titleSmall!.apply(
                fontSizeFactor: state.titleTextScaleFactor,
              ),
              labelLarge: textTheme.labelLarge!.apply(
                fontSizeFactor: state.labelTextScaleFactor,
              ),
              labelMedium: textTheme.labelMedium!.apply(
                fontSizeFactor: state.labelTextScaleFactor,
              ),
              labelSmall: textTheme.labelSmall!.apply(
                fontSizeFactor: state.labelTextScaleFactor,
              ),
              bodyLarge: textTheme.bodyLarge!.apply(
                fontSizeFactor: state.bodyTextScaleFactor,
              ),
              bodyMedium: textTheme.bodyMedium!.apply(
                fontSizeFactor: state.bodyTextScaleFactor,
              ),
              bodySmall: textTheme.bodySmall!.apply(
                fontSizeFactor: state.bodyTextScaleFactor,
              ),
            );

            final lightColorScheme = ColorScheme.fromSeed(
              seedColor: state.seedColor,
            );

            final lightTheme = lightDynamic != null
                ? ThemeData.from(
                    colorScheme: lightDynamic,
                    useMaterial3: true,
                    textTheme: adjustedTextTheme.apply(
                      bodyColor: lightDynamic.onSurface,
                    ),
                  )
                : ThemeData.from(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: state.seedColor,
                    ),
                    useMaterial3: true,
                    textTheme: adjustedTextTheme.apply(
                      bodyColor: lightColorScheme.onSurface,
                    ),
                  ).copyWith(
                    extensions: [
                      const AnimationThemeData(),
                    ],
                  );

            final darkColorScheme = ColorScheme.fromSeed(
              seedColor: state.seedColor,
              brightness: Brightness.dark,
            );

            final darkTheme = (darkDynamic != null
                    ? ThemeData.from(
                        colorScheme: darkDynamic,
                        useMaterial3: true,
                        textTheme: adjustedTextTheme.apply(
                          bodyColor: darkDynamic.onSurface,
                        ),
                      )
                    : ThemeData.from(
                        colorScheme: darkColorScheme,
                        textTheme: adjustedTextTheme.apply(
                          bodyColor: darkColorScheme.onSurface,
                        ),
                        useMaterial3: true,
                      ))
                .copyWith(
              extensions: [
                const AnimationThemeData(),
              ],
            );

            return _AppView(lightTheme, darkTheme, state.themeMode);
          },
        );
      },
    );
  }
}

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/db/db.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/theme/models/theme_config/theme_config.dart';
import 'package:muffed/theme/theme.dart';

/// Initialises app providers
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DB()),
      ],
      child: Builder(
        builder: (context) {
          return const _AppTheme();
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
    return BlocBuilder<DB, DBModel>(
      buildWhen: (previous, current) {
        if (previous.look != current.look) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            final lightColorScheme = lightDynamic ??
                ColorScheme.fromSeed(
                  seedColor: state.look.seedColor,
                );

            final darkColorScheme = darkDynamic ??
                ColorScheme.fromSeed(
                  seedColor: state.look.seedColor,
                  brightness: Brightness.dark,
                );

            final lightTextTheme = Typography.material2021(
              colorScheme: lightColorScheme,
            ).englishLike;
            final darkTextTheme =
                Typography.material2021(colorScheme: darkColorScheme)
                    .englishLike;

            final lightTheme = ThemeData.from(
              colorScheme: lightColorScheme,
              textTheme: _adjustTextTheme(lightTextTheme, state.look),
              useMaterial3: true,
            ).copyWith(extensions: [AnimationThemeData()]);

            final darkTheme = ThemeData.from(
              colorScheme: darkColorScheme,
              textTheme: darkTextTheme,
              useMaterial3: true,
             
            ).copyWith(extensions: [AnimationThemeData()]);

            return _AppView(
              lightTheme,
              darkTheme,
              state.look.colorSchemeMode,
            );
          },
        );
      },
    );
  }
}

TextTheme _adjustTextTheme(TextTheme textTheme, ThemeConfig config) {
  return textTheme.copyWith(
    titleLarge: textTheme.titleLarge!.apply(
      fontSizeFactor: config.titleTextScaleFactor,
    ),
    titleMedium: textTheme.titleMedium!.apply(
      fontSizeFactor: config.titleTextScaleFactor,
    ),
    titleSmall: textTheme.titleSmall!.apply(
      fontSizeFactor: config.titleTextScaleFactor,
    ),
    labelLarge: textTheme.labelLarge!.apply(
      fontSizeFactor: config.labelTextScaleFactor,
    ),
    labelMedium: textTheme.labelMedium!.apply(
      fontSizeFactor: config.labelTextScaleFactor,
    ),
    labelSmall: textTheme.labelSmall!.apply(
      fontSizeFactor: config.labelTextScaleFactor,
    ),
    bodyLarge: textTheme.bodyLarge!.apply(
      fontSizeFactor: config.bodyTextScaleFactor,
    ),
    bodyMedium: textTheme.bodyMedium!.apply(
      fontSizeFactor: config.bodyTextScaleFactor,
    ),
    bodySmall: textTheme.bodySmall!.apply(
      fontSizeFactor: config.bodyTextScaleFactor,
    ),
  );
}

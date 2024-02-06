import 'dart:developer';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router.dart';
import 'package:muffed/view/widgets/dynamic_navigation_bar/bloc/bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  // initialize hydrated bloc
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    log(
      record.message,
      level: record.level.value,
      time: record.time,
      error: record.error,
      name: record.loggerName,
      zone: record.zone,
      stackTrace: record.stackTrace,
      sequenceNumber: record.sequenceNumber,
    );
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => DynamicNavigationBarBloc()),
            BlocProvider(create: (context) => GlobalBloc()),
          ],
          child: BlocBuilder<GlobalBloc, GlobalState>(
            builder: (context, state) {
              return RepositoryProvider(
                create: (context) => ServerRepo(context.read<GlobalBloc>()),
                child: MaterialApp.router(
                  routerConfig: router,
                  title: 'Muffed',
                  builder: (context, child) {
                    final textTheme = Theme.of(context).textTheme;
                    return Theme(
                      data: Theme.of(context).copyWith(
                        textTheme: textTheme.apply().copyWith(
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
                            ),
                      ),
                      child: child!,
                    );
                  },
                  theme: ThemeData(
                    colorScheme:
                        (state.useDynamicColorScheme && lightDynamic != null)
                            ? lightDynamic
                            : ColorScheme.fromSeed(seedColor: state.seedColor),
                    useMaterial3: true,
                  ),
                  darkTheme: ThemeData(
                    colorScheme:
                        (state.useDynamicColorScheme && darkDynamic != null)
                            ? darkDynamic
                            : ColorScheme.fromSeed(
                                seedColor: state.seedColor,
                                brightness: Brightness.dark,
                              ),
                    useMaterial3: true,
                  ),
                  themeMode: state.themeMode,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

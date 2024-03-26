import 'package:flutter/material.dart';
import 'package:muffed/domain/local_options/bloc.dart';

class ThemeModeDialog extends StatefulWidget {
  const ThemeModeDialog(
      {required this.setThemeMode, required this.initialThemeMode, super.key});

  final ThemeMode initialThemeMode;
  final void Function(ThemeMode) setThemeMode;

  @override
  State<ThemeModeDialog> createState() => _ThemeModeDialogState();
}

class _ThemeModeDialogState extends State<ThemeModeDialog> {
  late ThemeMode themeMode;

  @override
  void initState() {
    super.initState();
    themeMode = widget.initialThemeMode;
  }

  String get title => 'Theme Mode';

  void onChanged(ThemeMode? t) {
    if (t != null) {
      setState(() {
        themeMode = t;
      });
    }
  }

  void onCancelPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onApplyPressed(BuildContext context) {
    widget.setThemeMode(themeMode);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: [
        RadioListTile(
          value: ThemeMode.dark,
          groupValue: themeMode,
          onChanged: onChanged,
          title: Text(ThemeMode.dark.toHumaneString()),
        ),
        RadioListTile(
          value: ThemeMode.light,
          groupValue: themeMode,
          onChanged: onChanged,
          title: Text(ThemeMode.light.toHumaneString()),
        ),
        RadioListTile(
          value: ThemeMode.system,
          groupValue: themeMode,
          onChanged: onChanged,
          title: Text(ThemeMode.system.toHumaneString()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: const Text('cancel'),
              onPressed: () => onCancelPressed(context),
            ),
            TextButton(
              child: const Text('apply'),
              onPressed: () => onApplyPressed(context),
            ),
          ],
        ),
      ],
    );
  }
}

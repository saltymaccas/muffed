import 'package:flutter/material.dart';
import 'package:muffed/view/pages/profile/models/models.dart';

class ColorSchemeDialog extends StatefulWidget {
  const ColorSchemeDialog({
    required this.initalColorScheme,
    required this.onChanged,
    super.key,
  });

  final ColorSchemeOptions initalColorScheme;
  final void Function(ColorSchemeOptions) onChanged;

  @override
  State<ColorSchemeDialog> createState() => _ColorSchemeDialogState();
}

class _ColorSchemeDialogState extends State<ColorSchemeDialog> {
  late ColorSchemeOptions value;

  @override
  void initState() {
    super.initState();
    value = widget.initalColorScheme;
  }

  void onChanged(ColorSchemeOptions? c) {
    if (c != null) {
      setState(() {
        value = c;
      });
    }
  }

  void onCancelPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void onApplyPressed(BuildContext context) {
    widget.onChanged(value);
    Navigator.pop(context);
  }

  String get title => 'Color Scheme';

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: [
        RadioListTile(
          title: Text(ColorSchemeOptions.purple.humaneString),
          value: ColorSchemeOptions.purple,
          groupValue: value,
          onChanged: onChanged,
        ),
        RadioListTile(
          title: Text(ColorSchemeOptions.blue.humaneString),
          value: ColorSchemeOptions.blue,
          groupValue: value,
          onChanged: onChanged,
        ),
        RadioListTile(
          title: Text(ColorSchemeOptions.green.humaneString),
          value: ColorSchemeOptions.green,
          groupValue: value,
          onChanged: onChanged,
        ),
        RadioListTile(
          title: Text(ColorSchemeOptions.red.humaneString),
          value: ColorSchemeOptions.red,
          groupValue: value,
          onChanged: onChanged,
        ),
        RadioListTile(
          title: Text(ColorSchemeOptions.system.humaneString),
          value: ColorSchemeOptions.system,
          groupValue: value,
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text('cancel'),
              onPressed: () => onCancelPressed(context),
            ),
            TextButton(
              child: Text('apply'),
              onPressed: () => onApplyPressed(context),
            ),
          ],
        ),
      ],
    );
  }
}

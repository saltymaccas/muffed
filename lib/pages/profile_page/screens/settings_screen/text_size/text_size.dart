import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../global_state/bloc.dart';

class TextSizeScreen extends StatelessWidget {
  const TextSizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Size'),
      ),
      body: ListView(
        children: [
          ListTile(
            selected: context.watch<GlobalBloc>().state.textScaleFactor == 0.8,
            title: const Text('Small'),
            onTap: () {
              context.read<GlobalBloc>().add(TextScaleFactorChanged(0.8));
            },
          ),
          ListTile(
            selected: context.watch<GlobalBloc>().state.textScaleFactor == 1.0,
            title: const Text('Medium'),
            onTap: () {
              context.read<GlobalBloc>().add(TextScaleFactorChanged(1.0));
            },
          ),
          ListTile(
            selected: context.watch<GlobalBloc>().state.textScaleFactor == 1.2,
            title: const Text('Large'),
            onTap: () {
              context.read<GlobalBloc>().add(TextScaleFactorChanged(1.2));
            },
          ),
          ListTile(
            selected: context.watch<GlobalBloc>().state.textScaleFactor == 1.5,
            title: const Text('Extra Large'),
            onTap: () {
              context.read<GlobalBloc>().add(TextScaleFactorChanged(1.5));
            },
          ),
        ],
      ),
    );
  }
}

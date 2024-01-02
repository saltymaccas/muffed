import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/router/router.dart';

class SettingsContentFiltersPage extends MPage<void> {
  SettingsContentFiltersPage();

  @override
  Widget build(BuildContext context) {
    return const _SettingsContentFiltersView();
  }
}

class _SettingsContentFiltersView extends StatelessWidget {
  const _SettingsContentFiltersView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Content Filters'),
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: ListView(
            children: [
              SwitchListTile(
                title: const Text('Show NSFW posts'),
                value: state.showNsfw,
                onChanged: (value) {
                  context.read<GlobalBloc>().add(
                        SettingChanged(
                          state.copyWith(
                            showNsfw: value,
                          ),
                        ),
                      );
                },
              ),
              if (state.showNsfw)
                SwitchListTile(
                  title: const Text('Blur NSFW posts'),
                  value: state.blurNsfw,
                  onChanged: (value) {
                    context
                        .read<GlobalBloc>()
                        .add(SettingChanged(state.copyWith(blurNsfw: value)));
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

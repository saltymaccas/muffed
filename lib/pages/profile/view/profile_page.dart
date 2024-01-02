import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/profile/profile.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/theme/theme.dart';

class ProfilePage extends MPage<void> {
  ProfilePage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        if (state.isLoggedIn) {
          return const _LoggedInProfileView();
        } else {
          return const _NotLoggedInProfileView();
        }
      },
    );
  }
}

class _NotLoggedInProfileView extends StatelessWidget {
  const _NotLoggedInProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 50,
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  'Anonymous',
                  style: context.textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                showAccountSwitcher(context);
              },
              child: const Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoggedInProfileView extends StatelessWidget {
  const _LoggedInProfileView();

  @override
  Widget build(BuildContext context) {
    final globalBloc = context.read<GlobalBloc>();

    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 50,
                    ),
                    TextButton(
                      onPressed: () => showAccountSwitcher(context),
                      child: Row(
                        children: [
                          Text(
                            globalBloc.getSelectedLemmyAccount()?.name ??
                                'Anonymous',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const Icon(Icons.arrow_drop_down_outlined),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (context.read<GlobalBloc>().state.isLoggedIn)
                      ElevatedButton(
                        onPressed: () {
                          // TODO: add navigation
                        },
                        child: const Text('Show saved posts'),
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

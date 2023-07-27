import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final globalBloc = context.read<GlobalBloc>();

    return SetPageInfo(
        indexOfRelevantItem: 2,
        actions: [],
        child: BlocBuilder<GlobalBloc, GlobalState>(
          builder: (context, state) {
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 100,
                  ),
                  TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                            useRootNavigator: true,
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ...List.generate(
                                      globalBloc.state.lemmyAccounts.length,
                                      (index) {
                                    return ListTile(
                                      title: Text(globalBloc
                                          .state.lemmyAccounts[index].userName),
                                      leading: Icon(Icons.account_circle),
                                      onTap: () {
                                        context.pop();
                                        globalBloc.add(
                                            UserRequestsLemmyAccountSwitch(
                                                index));
                                      },
                                    );
                                  }),
                                  ListTile(
                                    title: Text('Anonymous'),
                                    leading: Icon(Icons.security),
                                    onTap: () {
                                      context.pop();
                                      globalBloc.add(
                                          UserRequestsLemmyAccountSwitch(null));
                                    },
                                  ),
                                  ListTile(
                                    title: Text('Add Account'),
                                    leading: Icon(Icons.add),
                                    onTap: () {
                                      context.pop();
                                      context.go('/profile/login');
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Text(
                          globalBloc.getSelectedLemmyAccount()?.userName ??
                              'Anonymous'))
                ],
              ),
            );
          },
        ));
  }
}

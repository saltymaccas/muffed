import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/muffed_page.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';

import 'bloc/bloc.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          InboxBloc(repo: context.read<ServerRepo>())..add(Initialize()),
      child: BlocBuilder<InboxBloc, InboxState>(
        builder: (context, state) {
          return SetPageInfo(
            actions: [],
            indexOfRelevantItem: 1,
            child: Builder(
              builder: (context) {
                if (state.inboxItemsStatus == InboxStatus.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.inboxItemsStatus == InboxStatus.failure) {
                  return ErrorComponentTransparent(
                    message: state.error,
                    retryFunction: () =>
                        context.read<InboxBloc>().add(Initialize()),
                  );
                } else if (state.inboxItemsStatus == InboxStatus.success) {
                  return MuffedPage(
                    isLoading: state.isLoading,
                    error: state.error,
                    child: ListView(
                      children: List.generate(
                        state.inboxItems.length,
                        (index) => Text(state.inboxItems[index].content),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          );
        },
      ),
    );
  }
}

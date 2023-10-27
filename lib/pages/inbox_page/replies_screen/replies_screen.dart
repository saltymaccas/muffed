import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/comment_item/comment_item.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/muffed_page.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';

import 'bloc/bloc.dart';

class RepliesScreen extends StatelessWidget {
  const RepliesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepliesBloc, RepliesState>(
      builder: (context, state) {
        return SetPageInfo(
          actions: [],
          indexOfRelevantItem: 1,
          child: Builder(
            builder: (context) {
              if (state.replyItemsStatus == RepliesStatus.loading) {
                return Center(child: CircularProgressIndicator());
              } else if (state.replyItemsStatus == RepliesStatus.failure) {
                return ErrorComponentTransparent(
                  message: state.error,
                  retryFunction: () =>
                      context.read<RepliesBloc>().add(Initialize()),
                );
              } else if (state.replyItemsStatus == RepliesStatus.success) {
                return MuffedPage(
                  isLoading: state.isLoading,
                  error: state.error,
                  child: ListView(
                    children: List.generate(
                      state.replyItems.length,
                      (index) => CommentItem(
                        markedAsReadCallback: () {
                          print('test');
                        },
                        comment: state.replyItems[index].comment,
                        isOrphan: true,
                        displayAsSingle: true,
                        sortType: state.sortType,
                        ableToLoadChildren: false,
                      ),
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
    );
  }
}

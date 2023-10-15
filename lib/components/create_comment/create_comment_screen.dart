import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/create_comment/bloc/bloc.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';

import '../muffed_page.dart';

class CreateCommentScreen extends StatelessWidget {
  const CreateCommentScreen({required this.state, super.key});

  final CreateCommentState state;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateCommentBloc(
        repo: context.read<ServerRepo>(),
        onSuccess: () {},
        initialState: state,
      ),
      child: SetPageInfo(
        actions: const [],
        indexOfRelevantItem: 0,
        child: BlocBuilder<CreateCommentBloc, CreateCommentState>(
          builder: (context, state) {
            return MuffedPage(
              isLoading: state.isLoading,
              error: state.error,
              child: Scaffold(
                appBar: AppBar(title: Text('Create Comment')),
                body: Column(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}

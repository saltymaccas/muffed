import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_buttons.dart';
import 'package:markdown_editable_textinput/markdown_text_input_field.dart';
import 'package:muffed/repo/server_repo.dart';

import '../../dynamic_navigation_bar/dynamic_navigation_bar.dart';
import '../muffed_page.dart';
import 'bloc/bloc.dart';

class CreateCommentScreen extends StatelessWidget {
  const CreateCommentScreen({required this.state, super.key});

  final CreateCommentState state;

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final textFocusNode = FocusNode();

    return BlocProvider(
      create: (context) => CreateCommentBloc(
        repo: context.read<ServerRepo>(),
        onSuccess: () {},
        initialState: state,
      ),
      child: WillPopScope(
        onWillPop: () async {
          final bool? result = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Exit while discarding changes?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text('yes')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text('no')),
                ],
              );
            },
          );

          return result ?? false;
        },
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
                  body: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: MarkdownTextInputField(
                            initialValue: state.newCommentContents,
                            controller: textController,
                            focusNode: textFocusNode,
                            label: 'Comment...',
                            minLines: 8,
                            maxLines: null,
                          ),
                        ),
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: MarkdownButtons(
                              controller: textController,
                              focusNode: textFocusNode,
                              actions: const [
                                MarkdownType.image,
                                MarkdownType.link,
                                MarkdownType.bold,
                                MarkdownType.italic,
                                MarkdownType.blockquote,
                                MarkdownType.strikethrough,
                                MarkdownType.title,
                                MarkdownType.list,
                                MarkdownType.separator,
                                MarkdownType.code,
                              ],
                            ),
                          ),
                          Material(
                            elevation: 10,
                            // decoration: BoxDecoration(
                            //   border: Border(
                            //     left: BorderSide(
                            //       width: 1,
                            //       color: Theme.of(context)
                            //           .colorScheme
                            //           .outlineVariant,
                            //     ),
                            //   ),
                            // ),
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: (state.isPreviewing)
                                  ? IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                      onPressed: () {
                                        context
                                            .read<CreateCommentBloc>()
                                            .add(PreviewToggled());
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.remove_red_eye_outlined),
                                      onPressed: () {
                                        context
                                            .read<CreateCommentBloc>()
                                            .add(PreviewToggled());
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

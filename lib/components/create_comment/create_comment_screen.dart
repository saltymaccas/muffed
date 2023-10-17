import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_buttons.dart';
import 'package:markdown_editable_textinput/markdown_text_input_field.dart';
import 'package:muffed/components/markdown_body.dart';
import 'package:muffed/components/muffed_page.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';

import 'bloc/bloc.dart';

class CreateCommentScreen extends StatelessWidget {
  const CreateCommentScreen({
    required this.postId,
    this.initialValue,
    this.postBlocContext,
    this.parentId,
    super.key,
  });

  final int postId;
  final String? initialValue;

  /// If user is replying to a comment set this value as the comment is
  final int? parentId;

  /// If the comment is being added to the post the context of the bloc can be
  /// provided to allow the screen to show the post.
  final BuildContext? postBlocContext;

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final textFocusNode = FocusNode();

    return BlocProvider(
      create: (context) => CreateCommentBloc(
        repo: context.read<ServerRepo>(),
        onSuccess: () {},
      ),
      child: SetPageInfo(
        actions: const [],
        indexOfRelevantItem: 0,
        child: BlocBuilder<CreateCommentBloc, CreateCommentState>(
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () async {
                if (textController.text == '') {
                  return true;
                }
                final bool? result = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Discard'),
                      content: Text('Exit while discarding changes?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text('Yes')),
                        TextButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text('No')),
                      ],
                    );
                  },
                );

                return result ?? false;
              },
              child: MuffedPage(
                isLoading: state.isLoading,
                error: state.error,
                child: Scaffold(
                  appBar: AppBar(title: Text('Create Comment')),
                  body: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: IndexedStack(
                            index: (state.isPreviewing ? 0 : 1),
                            children: [
                              MuffedMarkdownBody(data: textController.text),
                              MarkdownTextInputField(
                                initialValue: initialValue,
                                controller: textController,
                                focusNode: textFocusNode,
                                label: 'Comment...',
                                minLines: 8,
                                maxLines: null,
                              ),
                            ],
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
                              child: IconButton(
                                isSelected: (state.isPreviewing),
                                icon: (state.isPreviewing)
                                    ? Icon(Icons.remove_red_eye)
                                    : Icon(Icons.remove_red_eye_outlined),
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
              ),
            );
          },
        ),
      ),
    );
  }
}

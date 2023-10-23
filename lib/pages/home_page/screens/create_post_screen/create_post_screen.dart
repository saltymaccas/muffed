import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_buttons.dart';
import 'package:markdown_editable_textinput/markdown_text_input_field.dart';
import 'package:muffed/components/markdown_body.dart';
import 'package:muffed/components/muffed_page.dart';
import 'package:muffed/components/snackbars.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';

import 'bloc/bloc.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen(
      {required this.communityId, this.community, super.key});

  final LemmyCommunity? community;
  final int communityId;

  @override
  Widget build(BuildContext context) {
    final TextEditingController bodyTextController = TextEditingController();
    final TextEditingController titleTextController = TextEditingController();
    final TextEditingController urlTextController = TextEditingController();

    final FocusNode bodyTextFocusNode = FocusNode();

    return BlocProvider(
      create: (context) => CreatePostBloc(
        communityId: communityId,
        communityInfo: community,
        repo: context.read<ServerRepo>(),
      )..add(Initalize()),
      child: BlocConsumer<CreatePostBloc, CreatePostState>(
        listener: (context, state) {
          if (state.successfullyPostedPost != null) {
            context
              ..pop()
              ..push(
                Uri(
                  path: '/home/content',
                ).toString(),
                extra: (state.successfullyPostedPost, null),
              );
            showInfoSnackBar(context, text: 'Post successfully posted');
          }
        },
        builder: (context, state) {
          return SetPageInfo(
            indexOfRelevantItem: 0,
            actions: [],
            child: MuffedPage(
              isLoading: state.isLoading,
              error: state.error,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Create post'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        if (titleTextController.text.isEmpty) {
                          showErrorSnackBar(
                            context,
                            error: 'Title must not be empty',
                          );
                        } else {
                          context.read<CreatePostBloc>().add(
                                PostSubmitted(
                                  title: titleTextController.text,
                                  body: bodyTextController.text,
                                  url: urlTextController.text,
                                ),
                              );
                        }
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextField(
                                controller: titleTextController,
                                decoration: const InputDecoration(
                                  hintText: 'Title',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextField(
                                controller: urlTextController,
                                decoration: const InputDecoration(
                                  hintText: 'Url',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: IndexedStack(
                                index: (state.isPreviewingBody ? 0 : 1),
                                children: [
                                  SingleChildScrollView(
                                    child: MuffedMarkdownBody(
                                      data: bodyTextController.text,
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: MarkdownTextInputField(
                                      controller: bodyTextController,
                                      focusNode: bodyTextFocusNode,
                                      label: 'Body',
                                      minLines: 5,
                                      maxLines: null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    Row(
                      children: [
                        Expanded(
                          child: MarkdownButtons(
                            controller: bodyTextController,
                            focusNode: bodyTextFocusNode,
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
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: IconButton(
                              isSelected: (state.isPreviewingBody),
                              icon: (state.isPreviewingBody)
                                  ? Icon(Icons.remove_red_eye)
                                  : Icon(Icons.remove_red_eye_outlined),
                              onPressed: () {
                                context
                                    .read<CreatePostBloc>()
                                    .add(PreviewToggled());
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 1),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

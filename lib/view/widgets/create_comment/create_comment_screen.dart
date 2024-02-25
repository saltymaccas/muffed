import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_buttons.dart';
import 'package:markdown_editable_textinput/markdown_text_input_field.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/widgets/create_comment/bloc/bloc.dart';
import 'package:muffed/view/widgets/image_upload_view.dart';
import 'package:muffed/view/widgets/markdown_body.dart';
import 'package:muffed/view/widgets/muffed_page.dart';

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
      child: BlocConsumer<CreateCommentBloc, CreateCommentState>(
        listener: (context, state) {
          if (state.successfullyPosted) {
            context.pop();
          }
        },
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
                    title: const Text('Discard'),
                    content: const Text('Exit while discarding changes?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('No'),
                      ),
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
                appBar: AppBar(
                  title: const Text('Create Comment'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        context.read<CreateCommentBloc>().add(
                              Submitted(
                                postId: postId,
                                commentContents: textController.text,
                                commentId: parentId,
                              ),
                            );
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (state.images.isNotEmpty)
                              ImageUploadView(
                                images: state.images,
                                onDelete: (id) {
                                  context
                                      .read<CreateCommentBloc>()
                                      .add(UploadedImageRemoved(id: id));
                                },
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: IndexedStack(
                                index: (state.isPreviewing ? 0 : 1),
                                children: [
                                  MuffedMarkdownBody(
                                    data: textController.text,
                                  ),
                                  MarkdownTextInputField(
                                    initialValue: initialValue,
                                    controller: textController,
                                    focusNode: textFocusNode,
                                    label: 'Comment...',
                                    minLines: 8,
                                  ),
                                ],
                              ),
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
                            customImageButtonAction: () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? file = await picker.pickImage(
                                source: ImageSource.gallery,
                              );

                              context.read<CreateCommentBloc>().add(
                                    ImageToUploadSelected(
                                      filePath: file!.path,
                                    ),
                                  );
                            },
                          ),
                        ),
                        Material(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: IconButton(
                              isSelected: state.isPreviewing,
                              icon: (state.isPreviewing)
                                  ? const Icon(Icons.remove_red_eye)
                                  : const Icon(Icons.remove_red_eye_outlined),
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
    );
  }
}

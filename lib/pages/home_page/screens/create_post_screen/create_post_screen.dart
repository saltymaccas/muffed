import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_buttons.dart';
import 'package:markdown_editable_textinput/markdown_text_input_field.dart';
import 'package:muffed/components/image.dart';
import 'package:muffed/components/image_upload_view.dart';
import 'package:muffed/components/markdown_body.dart';
import 'package:muffed/components/muffed_page.dart';
import 'package:muffed/components/snackbars.dart';
import 'package:muffed/components/url_view.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';

import 'bloc/bloc.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({
    required this.communityId,
    this.community,
    this.postBeingEdited,
    super.key,
  })  : bodyTextController = TextEditingController(text: postBeingEdited?.body),
        titleTextController =
            TextEditingController(text: postBeingEdited?.name),
        urlTextController = TextEditingController(),
        assert(postBeingEdited != null || communityId != null);

  final LemmyCommunity? community;

  /// should be defined if creating a new post
  final int? communityId;

  final TextEditingController bodyTextController;

  final TextEditingController titleTextController;

  final TextEditingController urlTextController;

  /// set this if the user is editing an already existing post rather than
  /// creating a new one
  final LemmyPost? postBeingEdited;

  final FocusNode bodyTextFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatePostBloc(
        communityId: communityId,
        communityInfo: community,
        postBeingEdited: postBeingEdited,
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
            showInfoSnackBar(
              context,
              text: (postBeingEdited == null)
                  ? 'Post successfully posted'
                  : 'Post successfully edited',
            );
          }
        },
        builder: (context, state) {
          Future<void> openImagePickerForImageUpload() async {
            final ImagePicker picker = ImagePicker();
            final XFile? file = await picker.pickImage(
              source: ImageSource.gallery,
            );

            context.read<CreatePostBloc>().add(
                  ImageToUploadSelected(
                    filePath: file!.path,
                  ),
                );
          }

          void runUrlAddedEvent() {
            context
                .read<CreatePostBloc>()
                .add(UrlAdded(url: urlTextController.text));
          }

          void runImageRemovedEvent() {
            context.read<CreatePostBloc>().add(ImageRemoved());
          }

          void showAddDialog() {
            showDialog<void>(
              context: context,
              builder: (context) => Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () {
                          context.pop();
                          showDialog<void>(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: urlTextController,
                                        decoration: const InputDecoration(
                                          hintText: 'Url',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          context.pop();
                                          runUrlAddedEvent();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            fixedSize: Size(500, 50)),
                                        child: Text('Add Url'),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        style:
                            ElevatedButton.styleFrom(fixedSize: Size(500, 50)),
                        child: Text('Add Url'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          context.pop();
                          openImagePickerForImageUpload();
                        },
                        style:
                            ElevatedButton.styleFrom(fixedSize: Size(500, 50)),
                        child: Text('Add Image'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SetPageInfo(
            page: Pages.home,
            actions: [],
            child: MuffedPage(
              isLoading: state.isLoading,
              error: state.error,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    (postBeingEdited == null) ? 'Create post' : 'Edit post',
                  ),
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
                            ImageUploadView(
                              images: state.bodyImages,
                              onDelete: (id) {
                                context
                                    .read<CreatePostBloc>()
                                    .add(UploadedBodyImageRemoved(id: id));
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextField(
                                controller: titleTextController,
                                decoration: const InputDecoration(
                                  hintText: 'Title',
                                  border: InputBorder.none,
                                ),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            if (state.url == null && state.image == null)
                              ElevatedButton(
                                onPressed: showAddDialog,
                                child: const Icon(Icons.add),
                              )
                            else if (state.url != null)
                              Material(
                                elevation: 5,
                                child: Stack(
                                  children: [
                                    UrlView(url: state.url!),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: IconButton(
                                            onPressed: () {
                                              context
                                                  .read<CreatePostBloc>()
                                                  .add(UrlRemoved());
                                            },
                                            style: IconButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer
                                                  .withOpacity(0.5),
                                            ),
                                            icon: Icon(Icons.close)),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else if (state.image != null)
                              if (state.image!.imageLink != null)
                                Stack(
                                  children: [
                                    MuffedImage(
                                      imageUrl: state.image!.imageLink!,
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog<void>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('Delete image?'),
                                                  content: Text(
                                                      'Are you sure you want to delete this image from the server?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        runImageRemovedEvent();
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Delete'),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        icon: Icon(Icons.delete),
                                        style: IconButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: LinearProgressIndicator(
                                    value: state.image!.uploadProgress,
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
                            customImageButtonAction: () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? file = await picker.pickImage(
                                source: ImageSource.gallery,
                              );

                              context.read<CreatePostBloc>().add(
                                    BodyImageToUploadSelected(
                                      filePath: file!.path,
                                    ),
                                  );
                            },
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

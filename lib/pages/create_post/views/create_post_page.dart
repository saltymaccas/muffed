import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_buttons.dart';
import 'package:markdown_editable_textinput/markdown_text_input_field.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/pages/create_post/create_post.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/models/extensions.dart';
import 'package:muffed/router/models/page.dart';
import 'package:muffed/router/models/page_actions.dart';
import 'package:muffed/theme/models/extentions.dart';
import 'package:muffed/widgets/image.dart';
import 'package:muffed/widgets/image_upload_view.dart';
import 'package:muffed/widgets/markdown_body.dart';
import 'package:muffed/widgets/snackbars.dart';
import 'package:muffed/widgets/url_view.dart';

/// A page that allows the user to create or edit a post.
class CreatePostPage extends MPage<void> {
  CreatePostPage({
    this.communityId,
    this.community,
    this.postBeingEdited,
  })  : assert(
          communityId != null || community != null,
          'No community was given',
        ),
        super(pageActions: PageActions.init());

  /// The id of the community the post will be posted to.
  final int? communityId;

  /// The community of the community the post will be posted to.
  final LemmyCommunity? community;

  /// If the screen is editing a post rather then creating one set this as
  /// the post being edited.
  final LemmyPost? postBeingEdited;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatePostBloc(
        recipientCommunityId: communityId,
        recipientCommunity: community,
        postBeingEdited: postBeingEdited,
        repo: context.read<ServerRepo>(),
      ),
      child: const CreatePostView(),
    );
  }
}

class CreatePostView extends StatefulWidget {
  const CreatePostView({
    super.key,
  });

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final TextEditingController bodyTextController = TextEditingController();
  final FocusNode bodyTextFocusNode = FocusNode();

  final TextEditingController titleTextController = TextEditingController();

  /// stores the value of the url that will be attached to the post
  final TextEditingController urlTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    bodyTextController.dispose();
    bodyTextFocusNode.dispose();
    titleTextController.dispose();
    urlTextController.dispose();
  }

  bool isPreviewingBody = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state.exception != null) {
          showExceptionSnackBar(context, state.exception!);
        }
        if (state.successfullyPostedPost != null) {
          context.popPageFromCurrentBranch();
          showInfoSnackBar(
            context,
            text: (context.read<CreatePostBloc>().isEditingPost)
                ? 'Post successfully edited'
                : 'Post successfully posted',
          );
        }
        if (state.isPosting) {
          bodyTextFocusNode.unfocus();
        }
      },
      builder: (context, state) {
        final bloc = context.read<CreatePostBloc>();

        Future<void> openImagePickerForImageUpload() async {
          final picker = ImagePicker();
          final file = await picker.pickImage(
            source: ImageSource.gallery,
          );

          if (context.mounted) {
            context.read<CreatePostBloc>().add(
                  ImageToUploadSelected(
                    filePath: file!.path,
                  ),
                );
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              (context.read<CreatePostBloc>().isEditingPost)
                  ? 'Edit post'
                  : 'Create post',
            ),
            actions: [
              if (state.isPosting)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    'Posting...',
                    style: context.textTheme.labelLarge!.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                )
              else
                IconButton(
                  onPressed: () {
                    if (titleTextController.text.isEmpty) {
                      showExceptionSnackBar(
                        context,
                        MException('Title must not be empty', null),
                      );
                    } else {
                      context.read<CreatePostBloc>().add(
                            PostSubmitted(
                              title: titleTextController.text,
                              body: bodyTextController.text,
                            ),
                          );
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
            ],
          ),
          body: Stack(
            children: [
              Column(
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: TextField(
                              controller: titleTextController,
                              enabled: !state.isPosting,
                              decoration: const InputDecoration(
                                hintText: 'Title',
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          if (state.enteredUrl == null && state.image == null)
                            ElevatedButton(
                              onPressed: (state.isPosting)
                                  ? null
                                  : () => showAddDialog(
                                        context: context,
                                        urlTextController: urlTextController,
                                        addEnteredURlCallback: () {
                                          context.read<CreatePostBloc>().add(
                                                UrlAdded(
                                                  url: urlTextController.text,
                                                ),
                                              );
                                        },
                                        openImagePickerForImageUpload:
                                            openImagePickerForImageUpload,
                                      ),
                              child: const Icon(Icons.add),
                            )
                          else if (state.enteredUrl != null)
                            Material(
                              elevation: 5,
                              child: Stack(
                                children: [
                                  UrlView(url: urlTextController.text),
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
                                        icon: const Icon(Icons.close),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (state.image != null)
                            if (state.image!.imageLink != null)
                              Stack(
                                children: [
                                  Container(
                                    color: context.colorScheme.scrim,
                                    height: 250,
                                    width: double.maxFinite,
                                    child: Center(
                                      child: MuffedImage(
                                        fullScreenable: true,
                                        imageUrl: state.image!.imageLink!,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog<void>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Delete image?'),
                                              content: const Text(
                                                'Are you sure you want to delete this image from the server?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    bloc.add(ImageRemoved());
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
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
                              index: (isPreviewingBody ? 0 : 1),
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
                                    minLines: 10,
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
                            final picker = ImagePicker();
                            final file = await picker.pickImage(
                              source: ImageSource.gallery,
                            );

                            if (context.mounted) {
                              context.read<CreatePostBloc>().add(
                                    BodyImageToUploadSelected(
                                      filePath: file!.path,
                                    ),
                                  );
                            }
                          },
                        ),
                      ),
                      Material(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: IconButton(
                            isSelected: isPreviewingBody,
                            selectedIcon: const Icon(Icons.remove_red_eye),
                            icon: const Icon(Icons.remove_red_eye_outlined),
                            onPressed: () {
                              setState(() {
                                isPreviewingBody = !isPreviewingBody;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                ],
              ),
              if (state.isPosting)
                const SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

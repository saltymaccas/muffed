import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/repo/server_repo.dart';

import '../markdown_body.dart';
import '../snackbars.dart';
import 'bloc/bloc.dart';

/// The dialog that a user uses to post a comment
///
/// This is only the widget so place it into a [showDialog] function for it to
/// show
class CreateCommentDialog extends StatelessWidget {
  ///
  const CreateCommentDialog({
    required this.postId,
    this.parentId,
    this.parentCommentContent,
    this.onSuccessfullySubmitted,
    this.postBlocContext,
    super.key,
  });

  /// The id of the post
  final int postId;

  /// The id of the comment the user wants to add a comment to
  ///
  /// Don't set if the user is commenting on the post itself
  final int? parentId;

  /// The contents of the comment the user is commenting on
  ///
  /// only set if the user is replying to a comment and not a post
  ///
  /// Used to display the comment on the dialog so the user can use it for
  /// reference
  final String? parentCommentContent;

  /// The function to run if the comment goes through successfully
  final void Function()? onSuccessfullySubmitted;

  /// context of the post bloc can be
  /// provided to allow the screen to show the post.
  final BuildContext? postBlocContext;

  @override
  Widget build(BuildContext context) {
    final textFieldController = TextEditingController();

    return BlocProvider(
      create: (context) => CreateCommentBloc(
        repo: context.read<ServerRepo>(),
        onSuccess: () {},
      ),
      child: BlocConsumer<CreateCommentBloc, CreateCommentState>(
        listener: (context, state) {
          // closes the dialog if the comment has been successfully posted
          if (state.successfullyPosted) {
            context.pop();
            if (onSuccessfullySubmitted != null) {
              onSuccessfullySubmitted!.call();
            }
          }
          if (state.error != null) {
            showErrorSnackBar(context, error: state.error);
          }
        },
        builder: (context, state) {
          return Dialog(
            clipBehavior: Clip.hardEdge,
            insetPadding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (parentCommentContent != null) ...[
                  Flexible(
                    flex: 2,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: MuffedMarkdownBody(
                        data: parentCommentContent!,
                      ),
                    ),
                  ),
                  const Divider(),
                ],
                SizedBox(
                  height: 5,
                  child: state.isLoading
                      ? const LinearProgressIndicator()
                      : Container(),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: IndexedStack(
                      index: (state.isPreviewing) ? 0 : 1,
                      children: [
                        MuffedMarkdownBody(
                          data: textFieldController.text,
                          physics: ClampingScrollPhysics(),
                        ),
                        TextField(
                          controller: textFieldController,
                          autofocus: true,
                          autocorrect: true,
                          keyboardType: TextInputType.multiline,
                          minLines: 5,
                          maxLines: null,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(Icons.close),
                      ),
                      IconButton(
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
                      IconButton(
                        onPressed: () {
                          context
                            ..push(
                              Uri(
                                path: '/home/content/create_comment',
                                queryParameters: {
                                  'postId': postId.toString(),
                                  if (parentId != null)
                                    'parentCommentId': parentId,
                                  'initialValue': textFieldController.text,
                                },
                              ).toString(),
                              extra: postBlocContext,
                            )
                            ..pop();
                        },
                        icon: const Icon(Icons.open_in_new),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<CreateCommentBloc>().add(
                                Submitted(
                                  postId: postId,
                                  commentContents: textFieldController.text,
                                  commentId: parentId,
                                ),
                              );
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

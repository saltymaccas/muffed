import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/create_comment/bloc/bloc.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/markdown_body.dart';
import 'package:muffed/repo/server_repo.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateCommentBloc(
        initialState: CreateCommentState(
          postId: postId,
          parentCommentContents: parentCommentContent,
          parentId: parentId,
        ),
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
        },
        // prevents rebuilding when only the text changed and nothing else
        buildWhen: (previous, current) {
          if (previous.copyWith(newCommentContents: '') !=
              current.copyWith(
                newCommentContents: '',
              )) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          return Dialog(
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.parentCommentContents != null) ...[
                  Flexible(
                    flex: 2,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: MuffedMarkdownBody(
                        data: state.parentCommentContents!,
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
                    child: TextField(
                      autofocus: true,
                      autocorrect: true,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: null,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      onChanged: (text) {
                        context
                            .read<CreateCommentBloc>()
                            .add(NewCommentTextboxChanged(text));
                      },
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
                      if (state.error != null)
                        ErrorComponentTransparent(
                          message: state.error,
                          showErrorIcon: false,
                          textAlign: TextAlign.start,
                        )
                      else
                        const SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<CreateCommentBloc>()
                                  .add(Submitted());
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                            child: const Text(
                              'Comment',
                            ),
                          ),
                        ],
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
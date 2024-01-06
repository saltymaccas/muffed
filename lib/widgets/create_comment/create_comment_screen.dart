import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_buttons.dart';
import 'package:markdown_editable_textinput/markdown_text_input_field.dart';
import 'package:muffed/router/models/models.dart';
import 'package:muffed/theme/models/extentions.dart';
import 'package:muffed/widgets/markdown_body.dart';

// class CreateCommentPage extends MPage<void> {
//   CreateCommentPage({
//     required this.postId,
//     this.initialValue,
//     this.parentId,
//     this.onSuccess,
//   });

//   final int postId;
//   final String? initialValue;
//   final int? parentId;
//   final void Function()? onSuccess;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CreateCommentBloc(
//         repo: context.read<ServerRepo>(),
//       ),
//       child: CreateCommentView(
//         postId: postId,
//         initialValue: initialValue,
//         parentId: parentId,
//       ),
//     );
//   }
// }

// class CreateCommentView extends StatefulWidget {
//   const CreateCommentView({
//     required this.postId,
//     this.initialValue,
//     this.parentId,
//     this.onSuccess,
//     super.key,
//   });

//   final int postId;
//   final String? initialValue;

//   /// If user is replying to a comment set this value as the comment is
//   final int? parentId;

//   final void Function()? onSuccess;

//   @override
//   State<CreateCommentView> createState() => _CreateCommentViewState();
// }

// class _CreateCommentViewState extends State<CreateCommentView> {
//   final textController = TextEditingController();
//   final textFocusNode = FocusNode();

//   late bool canPop;

//   @override
//   void initState() {
//     super.initState();
//     textController.text = widget.initialValue ?? '';
//     canPop = textController.text.isEmpty;

//     textController.addListener(() {
//       if (canPop != textController.text.isEmpty) {
//         setState(() {
//           canPop = textController.text.isEmpty;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     textController.dispose();
//     textFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: canPop,
//       onPopInvoked: (bool didPop) {
//         if (!didPop) {
//           showDialog<void>(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: const Text('Discard'),
//                 content: const Text('Exit while discarding changes?'),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text('No'),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       context.popPageFromCurrentBranch();
//                     },
//                     child: const Text('Yes'),
//                   ),
//                 ],
//               );
//             },
//           );
//         }
//       },
//       child: BlocConsumer<CreateCommentBloc, CreateCommentState>(
//         listener: (context, state) {
//           if (state.successfullyPosted) {
//             widget.onSuccess?.call();
//             context.popPageFromCurrentBranch();
//           }
//         },
//         builder: (context, state) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Create Comment'),
//               actions: [
//                 if (state.isPosting)
//                   Padding(
//                     padding: const EdgeInsets.only(right: 8),
//                     child: Text(
//                       'Posting...',
//                       style: context.textTheme.labelLarge!.copyWith(
//                         color: context.colorScheme.primary,
//                       ),
//                     ),
//                   )
//                 else
//                   IconButton(
//                     onPressed: () {
//                       context.read<CreateCommentBloc>().add(
//                             Submitted(
//                               postId: widget.postId,
//                               commentContents: textController.text,
//                               commentId: widget.parentId,
//                             ),
//                           );
//                     },
//                     icon: const Icon(Icons.send),
//                   ),
//               ],
//             ),
//             body: Stack(
//               children: [
//                 Column(
//                   children: [
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             if (state.images.isNotEmpty)
//                               ImageUploadView(
//                                 images: state.images,
//                                 onDelete: (id) {
//                                   context
//                                       .read<CreateCommentBloc>()
//                                       .add(UploadedImageRemoved(id: id));
//                                 },
//                               ),
//                             Padding(
//                               padding: const EdgeInsets.all(8),
//                               child: IndexedStack(
//                                 index: (state.isPreviewing ? 0 : 1),
//                                 children: [
//                                   MuffedMarkdownBody(
//                                     data: textController.text,
//                                   ),
//                                   MarkdownTextInputField(
//                                     initialValue: widget.initialValue,
//                                     controller: textController,
//                                     focusNode: textFocusNode,
//                                     label: 'Comment...',
//                                     minLines: 8,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const Divider(),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: MarkdownButtons(
//                             controller: textController,
//                             focusNode: textFocusNode,
//                             actions: const [
//                               MarkdownType.image,
//                               MarkdownType.link,
//                               MarkdownType.bold,
//                               MarkdownType.italic,
//                               MarkdownType.blockquote,
//                               MarkdownType.strikethrough,
//                               MarkdownType.title,
//                               MarkdownType.list,
//                               MarkdownType.separator,
//                               MarkdownType.code,
//                             ],
//                             customImageButtonAction: () async {
//                               final picker = ImagePicker();
//                               final file = await picker.pickImage(
//                                 source: ImageSource.gallery,
//                               );

//                               context.read<CreateCommentBloc>().add(
//                                     ImageToUploadSelected(
//                                       filePath: file!.path,
//                                     ),
//                                   );
//                             },
//                           ),
//                         ),
//                         Material(
//                           elevation: 10,
//                           child: Padding(
//                             padding: const EdgeInsets.all(4),
//                             child: IconButton(
//                               isSelected: state.isPreviewing,
//                               icon: (state.isPreviewing)
//                                   ? const Icon(Icons.remove_red_eye)
//                                   : const Icon(Icons.remove_red_eye_outlined),
//                               onPressed: () {
//                                 context
//                                     .read<CreateCommentBloc>()
//                                     .add(PreviewToggled());
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 if (state.isPosting)
//                   const SafeArea(
//                     child: Align(
//                       alignment: Alignment.topCenter,
//                       child: LinearProgressIndicator(),
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

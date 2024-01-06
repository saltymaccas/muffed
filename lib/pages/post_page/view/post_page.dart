// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:muffed/db/db.dart';
// import 'package:muffed/pages/post_page/post_page.dart';
// import 'package:muffed/repo/server_repo.dart';
// import 'package:muffed/router/router.dart';
// import 'package:muffed/widgets/content_scroll/content_scroll.dart';
// import 'package:muffed/widgets/create_comment/create_comment_dialog.dart';
// import 'package:muffed/widgets/popup_menu/popup_menu.dart';
// import 'package:muffed/widgets/post/post.dart';
// import 'package:muffed/widgets/snackbars.dart';

// /// A Page that shows the post on top and the comments under
// class PostPage extends MPage<void> {
//   PostPage({int? postId, this.post, this.postBloc})
//       : assert(
//           post != null || postId != null || postBloc != null,
//           'No post defined in PostPage constructor',
//         ),
//         postId = postId ?? post?.id ?? postBloc!.state.post!.id;

//   final int postId;
//   final LemmyPost? post;
//   final PostBloc? postBloc;

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => ContentScrollBloc(
//             contentRetriever: CommentRetriever(
//               lem: context.read<ServerRepo>(),
//               postId: postId,
//             ),
//           )..add(LoadInitialItems()),
//         ),
//         if (postBloc != null)
//           BlocProvider.value(value: postBloc!)
//         else
//           BlocProvider(
//             create: (context) => PostBloc(
//               repo: context.read<ServerRepo>(),
//               globalBloc: context.read<DB>(),
//               post: post,
//               postId: postId,
//             )..add(Initialize()),
//           ),
//       ],
//       child: Builder(
//         builder: (context) {
//           final contentScrollBloc =
//               context.read<ContentScrollBloc<LemmyComment>>();
//           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//             pageActions.setActions(
//               [
//                 BlocBuilder<ContentScrollBloc<LemmyComment>,
//                     ContentScrollState<LemmyComment>>(
//                   bloc: contentScrollBloc,
//                   builder: (context, state) {
//                     final retrieveContent =
//                         state.contentDelegate as CommentRetriever;

//                     void changeSortType(LemmyCommentSortType sortType) {
//                       contentScrollBloc.add(
//                         RetrieveContentDelegateChanged(
//                           retrieveContent.copyWith(sortType: sortType),
//                         ),
//                       );
//                     }

//                     return MuffedPopupMenuButton(
//                       icon: const Icon(Icons.sort),
//                       visualDensity: VisualDensity.compact,
//                       selectedValue: retrieveContent.sortType,
//                       items: [
//                         MuffedPopupMenuItem(
//                           title: 'Hot',
//                           icon: const Icon(Icons.local_fire_department),
//                           value: LemmyCommentSortType.hot,
//                           onTap: () => changeSortType(LemmyCommentSortType.hot),
//                         ),
//                         MuffedPopupMenuItem(
//                           title: 'Top',
//                           icon: const Icon(Icons.military_tech),
//                           value: LemmyCommentSortType.top,
//                           onTap: () => changeSortType(LemmyCommentSortType.top),
//                         ),
//                         MuffedPopupMenuItem(
//                           title: 'New',
//                           icon: const Icon(Icons.auto_awesome),
//                           value: LemmyCommentSortType.latest,
//                           onTap: () =>
//                               changeSortType(LemmyCommentSortType.latest),
//                         ),
//                         MuffedPopupMenuItem(
//                           title: 'Old',
//                           icon: const Icon(Icons.elderly),
//                           value: LemmyCommentSortType.old,
//                           onTap: () => changeSortType(LemmyCommentSortType.old),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//                 if (context.db.state.auth.lemmy.loggedIn)
//                   IconButton(
//                     onPressed: () {
//                       showCreateCommentDialog(
//                         context: context,
//                         postId: postId,
//                         onSuccessfullySubmitted: () => showInfoSnackBar(
//                           context,
//                           text: 'Comment successfully posted',
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.add),
//                     visualDensity: VisualDensity.compact,
//                   ),
//               ],
//             );
//           });

//           return const _PostView();
//         },
//       ),
//     );
//   }
// }

// class _PostView extends StatelessWidget {
//   const _PostView();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ContentScrollBloc<LemmyComment>,
//         ContentScrollState<LemmyComment>>(
//       builder: (context, state) {
//         return Scaffold(
//           body: ContentScrollView(
//             builderDelegate: LemmyCommentTreeContentBuilderDelegate(
//               (state.contentDelegate as CommentRetriever).sortType,
//             ),
//             headerSlivers: [
//               const SliverAppBar(
//                 title: Text('Comments'),
//                 floating: true,
//                 snap: true,
//               ),
//               SliverToBoxAdapter(
//                 child: PostWidget(
//                   displayType: PostDisplayType.comments,
//                   form: PostViewForm.card,
//                   bloc: context.read<PostBloc>(),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

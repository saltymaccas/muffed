import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/db/db.dart';
import 'package:muffed/interfaces/lemmy/lemmy.dart';
import 'package:muffed/interfaces/lemmy/models/extenstion.dart';
import 'package:muffed/pages/create_post/views/create_post_page.dart';
import 'package:muffed/pages/search/search.dart';
import 'package:muffed/router/models/models.dart';
import 'package:muffed/widgets/popup_menu/popup_menu.dart';

// class CommunityPage extends MPage<void> {
//   CommunityPage({
//     int? communityId,
//     String? communityName,
//     this.communityView,
//   })  : communityId = communityId ?? communityView?.community.id,
//         communityName = communityName ?? communityView?.community.name,
//         assert(
//           communityId != null || communityName != null || communityView != null,
//           'No community defined',
//         );

//   /// The community ID
//   final int? communityId;

//   /// The community name
//   final String? communityName;

//   /// The community object which contains the community information.
//   ///
//   /// If this is set to null the information will be loaded from the API.
//   /// Setting the value will mean the community information can be shown
//   /// instantly
//   final CommunityView? communityView;

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<CommunityScreenBloc>(
//           create: (context) => CommunityScreenBloc(
//             communityId: communityId,
//             communityView: communityView,
//             communityName: communityName,
//             lemClient: context.lemmy,
//           )..add(InitialiseCommunityScreen()),
//         ),
//       ],
//       child: Builder(
//         builder: (context) {
//           final contentScrollBloc =
//               context.read<ContentScrollBloc<Post>>();

//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             void changeSortType(SortType sortType) {
//               // FIXME:
//               context.read<ContentScrollBloc<Post>>().add(
//                     RetrieveContentDelegateChanged(
//                       (contentScrollBloc.state.contentDelegate
//                               )
//                           ,
//                     ),
//                   );
//             }

//             pageActions.setActions([
//               IconButton(
//                 onPressed: () {
//                   context.pushPage(
//                     SearchPage(
//                       communityId:
//                           context.read<CommunityScreenBloc>().communityId,
//                       communityName:
//                           context.read<CommunityScreenBloc>().communityName,
//                     ),
//                   );
//                 },
//                 icon: const Icon(Icons.search),
//                 visualDensity: VisualDensity.compact,
//               ),
//               BlocBuilder<ContentScrollBloc<Post>,
//                   ContentScrollState<Post>>(
//                 bloc: contentScrollBloc,
//                 builder: (context, state) {
//                   return MuffedPopupMenuButton(
//                     visualDensity: VisualDensity.compact,
//                     icon: const Icon(Icons.sort),
//                     selectedValue: SortType.hot,
//                     items: [
//                       MuffedPopupMenuItem(
//                         title: 'Hot',
//                         icon: const Icon(Icons.local_fire_department),
//                         value: SortType.hot,
//                         onTap: () => changeSortType(SortType.hot),
//                       ),
//                       MuffedPopupMenuItem(
//                         title: 'Active',
//                         icon: const Icon(Icons.rocket_launch),
//                         value: SortType.active,
//                         onTap: () => changeSortType(SortType.active),
//                       ),
//                       MuffedPopupMenuItem(
//                         title: 'New',
//                         icon: const Icon(Icons.auto_awesome),
//                         value: SortType.new_,
//                         onTap: () => changeSortType(SortType.new_),
//                       ),
//                       MuffedPopupMenuExpandableItem(
//                         title: 'Top',
//                         items: [
//                           MuffedPopupMenuItem(
//                             title: 'All Time',
//                             icon: const Icon(Icons.military_tech),
//                             value: SortType.topAll,
//                             onTap: () => changeSortType(SortType.topAll),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'Year',
//                             icon: const Icon(Icons.calendar_today),
//                             value: SortType.topYear,
//                             onTap: () => changeSortType(SortType.topYear),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'Month',
//                             icon: const Icon(Icons.calendar_month),
//                             value: SortType.topMonth,
//                             onTap: () => changeSortType(SortType.topMonth),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'Week',
//                             icon: const Icon(Icons.view_week),
//                             value: SortType.topWeek,
//                             onTap: () => changeSortType(SortType.topWeek),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'Day',
//                             icon: const Icon(Icons.view_day),
//                             value: SortType.topDay,
//                             onTap: () => changeSortType(SortType.topDay),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'Twelve Hours',
//                             icon: const Icon(Icons.schedule),
//                             value: SortType.topTwelveHour,
//                             onTap: () =>
//                                 changeSortType(SortType.topTwelveHour),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'Six Hours',
//                             icon: const Icon(Icons.view_module_outlined),
//                             value: SortType.topSixHour,
//                             onTap: () =>
//                                 changeSortType(SortType.topSixHour),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'Hour',
//                             icon: const Icon(Icons.hourglass_bottom),
//                             value: SortType.topHour,
//                             onTap: () => changeSortType(SortType.topHour),
//                           ),
//                         ],
//                       ),
//                       MuffedPopupMenuExpandableItem(
//                         title: 'Comments',
//                         items: [
//                           MuffedPopupMenuItem(
//                             title: 'Most Comments',
//                             icon: const Icon(Icons.comment_bank),
//                             value: SortType.mostComments,
//                             onTap: () =>
//                                 changeSortType(SortType.mostComments),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'New Comments',
//                             icon: const Icon(Icons.add_comment),
//                             value: SortType.newComments,
//                             onTap: () =>
//                                 changeSortType(SortType.newComments),
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               if (context.db.state.auth.lemmy.loggedIn)
//                 IconButton(
//                   onPressed: () {
//                     context.pushPage(
//                       CreatePostPage(
//                         communityId: communityId ?? communityView!.community.id,
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.add),
//                   visualDensity: VisualDensity.compact,
//                 ),
//             ]);
//           });
//           return const CommunityDisplay();
//         },
//       ),
//     );
//   }
// }

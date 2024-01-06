import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/theme/theme.dart';
import 'package:muffed/widgets/muffed_avatar.dart';

// class CommunityListTile extends StatelessWidget {
//   const CommunityListTile(
//     this.community, {
//     super.key,
//   });

//   factory CommunityListTile.compact(
//     CommunityView community, {
//     Key? key,
//   }) {
//     return _CompactCommunityListTile(community, key: key);
//   }

//   final CommunityView community;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         context.pushPage(
//           CommunityPage(
//             communityView: community,
//           ),
//         );
//       },
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               vertical: 8,
//             ),
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(
//                     16,
//                   ),
//                   child: MuffedAvatar(
//                     url: community.community.icon,
//                     radius: 16,
//                   ),
//                 ),
//                 Flexible(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         community.community.title,
//                         style: context.textTheme.titleMedium,
//                       ),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: '${community.counts.subscribers}',
//                               style: context.textTheme.bodySmall!.copyWith(
//                                 color: Theme.of(
//                                   context,
//                                 ).colorScheme.outline,
//                               ),
//                             ),
//                             TextSpan(
//                               text: ' members ',
//                               style: context.textTheme.bodySmall!.copyWith(
//                                 color: Theme.of(
//                                   context,
//                                 ).colorScheme.outline,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 4,
//                       ),
//                       if (community.community.description != null)
//                         Text(
//                           community.community.description!,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: context.textTheme.bodySmall!.copyWith(
//                             color: Theme.of(
//                               context,
//                             ).colorScheme.outline,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1),
//         ],
//       ),
//     );
//   }
// }

// class _CompactCommunityListTile extends CommunityListTile {
//   const _CompactCommunityListTile(super.community, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         InkWell(
//           onTap: () {
//             Navigator.pop(context);
//             context.pushPage(CommunityPage(communityView: community));
//           },
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 8,
//             ),
//             child: Row(
//               children: [
//                 MuffedAvatar(
//                   url: community.community.icon,
//                   identiconID: community.community.name,
//                   radius: 12,
//                 ),
//                 const SizedBox(
//                   width: 8,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       community.community.name,
//                     ),
//                     Text(
//                       '${community.counts.subscribers} members',
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: context.colorScheme.outline,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const Divider(),
//       ],
//     );
//   }
// }

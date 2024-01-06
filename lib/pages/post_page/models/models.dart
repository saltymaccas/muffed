import 'package:muffed/interfaces/lemmy/lemmy.dart';
import 'package:muffed/widgets/content_scroll/content_scroll.dart';

/// FIXME: Keeps on loading the same comments over and over again

/// Defines how the comments will be retrieved for the [ContentScrollView]
// class CommentRetriever extends ContentRetrieverDelegate<CommentView> {
//   const CommentRetriever({
//     required this.postId,
//     required this.lem,
//     this.sortType = CommentSortType.hot,
//   });

//   final int postId;
//   final LemmyClient lem;
//   final LemmyCommentSortType sortType;

//   @override
//   Future<List<LemmyComment>> retrieveContent({required int page}) async {
//     return lem.getComments(

//       postId: postId,
//       page: page,
//       sort: sortType,
//     );
//   }

//   @override
//   List<Object?> get props => [postId, lem, sortType];

//   CommentRetriever copyWith({
//     int? postId,
//     ServerRepo? repo,
//     LemmyCommentSortType? sortType,
//   }) {
//     return CommentRetriever(
//       postId: postId ?? this.postId,
//       lem: repo ?? this.lem,
//       sortType: sortType ?? this.sortType,
//     );
//   }
// }

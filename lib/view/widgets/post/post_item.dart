import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/widgets/post/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The forms posts can be displayed in
enum PostViewForm { card }

/// The types of ways the posts can display in
///
/// [list] - Used for when the post is displayed in a list
/// [comments] - Used for when the post is displayed at the top of a comment
/// section
enum PostDisplayType { list, comments }

/// A widget that displays a post, The form the post is displayed in can be
/// changed with [PostViewForm]
class PostItem extends StatefulWidget {
  const PostItem({
    this.post,
    this.bloc,
    this.displayType = PostDisplayType.list,
    super.key,
  }) : assert(post != null || bloc != null, 'no post provided in post item');

  final PostView? post;
  final PostDisplayType displayType;
  final PostBloc? bloc;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late final PostBloc bloc;

  @override
  void initState() {
    super.initState();

    final lemRepo = context.read<ServerRepo>().lemmyRepo;

    bloc = widget.bloc ?? PostBloc(lemmyRepo: lemRepo, post: widget.post!);
  }

  @override
  Widget build(BuildContext context) {
    return;
  }
}

final placeholderPost = LemmyPost(
  id: 213,
  name: 'placeholder',
  body: '''
Lorem ipsum dolor sit amet. 
      Sed autem consectetur et assumenda 
      voluptas ut expedita recusandae ad excepturi incidunt ut repellendus 
      itaque. Et sunt totam qui consequatur quisquam eum aliquam placeat.''',
  creatorId: 123,
  communityId: 123,
  nsfw: false,
  score: 123,
  communityName: 'placeholder',
  creatorName: 'placeholder',
  read: false,
  saved: false,
  apId: 'placeholder',
  timePublished: DateTime.now(),
  commentCount: 21,
  downVotes: 11,
  upVotes: 11,
  communityIcon: null,
);

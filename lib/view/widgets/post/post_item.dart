import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:logging/logging.dart';
import 'package:muffed/domain/lemmy/lemmy.dart';
import 'package:muffed/domain/lemmy_keychain/bloc.dart';
import 'package:muffed/view/pages/community/community_screen.dart';
import 'package:muffed/view/pages/post_screen/post_screen.dart';
import 'package:muffed/view/pages/user_screen/user_screen.dart';
import 'package:muffed/view/router/models/page.dart';
import 'package:muffed/view/router/navigator/navigator.dart';
import 'package:muffed/view/widgets/post/bloc/bloc.dart';
import 'package:muffed/view/widgets/post/widgets/card.dart';
import 'package:skeletonizer/skeletonizer.dart';

final _log = Logger('PostWidget');

/// The types of ways the posts can display in
///
/// [list] - Used for when the post is displayed in a list
/// [comments] - Used for when the post is displayed at the top of a comment
/// section
enum PostDisplayType { list, comments }

/// A widget that displays a post, The form the post is displayed in can be
/// changed with [PostViewForm]
class PostWidget extends StatefulWidget {
  const PostWidget({
    this.post,
    this.bloc,
    this.displayType = PostDisplayType.list,
    super.key,
  }) : assert(post != null || bloc != null, 'no post provided in post item');

  final PostView? post;

  final PostDisplayType displayType;
  final PostBloc? bloc;
  @override
  State<PostWidget> createState() => _PostWidgetState();
}

/// The forms posts can be displayed in
enum PostViewForm { card }

class _PostWidgetState extends State<PostWidget> {
  late final PostBloc bloc;

  late bool isAuthenticated;

  @override
  void initState() {
    super.initState();

    final lemRepo = context.read<LemmyRepo>();
    isAuthenticated = context.read<LemmyKeychainBloc>().state.isAuthenticated;

    bloc = widget.bloc ?? PostBloc(lemmyRepo: lemRepo, post: widget.post);
  }

  void onTap(BuildContext context) {
    MNavigator.of(context).pushPage(
      MuffedPage(
        builder: (context) => PostScreen(
          postBloc: bloc,
          postId: bloc.state.post?.post.id ?? widget.post?.post.id,
        ),
      ),
    );
  }

  void onCommunityTap(BuildContext context) {
    final communityId = bloc.state.post?.community.id;

    if (communityId != null) {
      MNavigator.of(context).pushPage(
        MuffedPage(
          builder: (context) => CommunityScreen(communityId: communityId),
        ),
      );
    } else {
      _log.warning('onCommunityTapCalled when no commmunity id defined');
    }
  }

  void onCreatorTap(BuildContext context) {
    final creatorId = bloc.state.post?.creator.id;

    if (creatorId != null) {
      MNavigator.of(context).pushPage(
        MuffedPage(builder: (context) => UserScreen(userId: creatorId)),
      );
    } else {
      _log.warning('onCreatorTap called when no creator id defined');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      bloc: bloc,
      builder: (context, state) {
        if (state.post == null) {
          return Skeletonizer(
            child: CardLemmyPostItem(
              nsfw: false,
              isAuthenticated: false,
              name: 'lorem ipsum',
              vote: 0,
              communityName: 'lorem ipsum',
              creatorName: 'lorem ipsum',
              timePublished: DateTime.fromMillisecondsSinceEpoch(0),
              saved: false,
              upvotes: 999,
              downvotes: 999,
              commentCount: 999,
            ),
          );
        }

        return CardLemmyPostItem.fromPostView(
          post: state.post!,
          isAuthenticated: isAuthenticated,
          onTap: () => onTap(context),
          onCommunityTap: () => onCommunityTap(context),
          onCreatorTap: () => onCreatorTap(context),
        );
      },
    );
  }
}

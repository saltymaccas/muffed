import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'lemmy/models.dart';

interface class LemmyRepo {
  final Client client;

  LemmyRepo() : client = Client();

  Future<List<LemmyPost>> getPosts(
      {LemmySortType sortType = LemmySortType.hot, int page = 1}) async {
    try {
      final response = await client.get(
        Uri.https(
          'lemmy.ml',
          'api/v3/post/list',
          {
            'page': page.toString(),
            'sort': lemmySortTypeEnumToApiCompatible[sortType],
          },
        ),
      );

      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      }

      var decodedResponse =
      (jsonDecode(utf8.decode(response.bodyBytes)) as Map)['posts'];

      List<LemmyPost> posts = [];

      for (Map<String, dynamic> post in decodedResponse) {
        posts.add(
          LemmyPost(
            body: post['post']['body'],
            url: post['post']['url'],
            id: post['post']['id'],
            name: post['post']['name'],
            timePublished: DateTime.parse(
                post['post']['published'] + 'Z'),
            // Z added to mark as UTC time
            nsfw: post['post']['nsfw'],
            creatorId: post['post']['creator_id'],
            creatorName: post['creator']['name'],
            communityId: post['post']['community_id'],
            communityName: post['community']['name'],
            communityIcon: post['community']['icon'],
            commentCount: post['counts']['comments'],
            upVotes: post['counts']['upvotes'],
            downVotes: post['counts']['downvotes'],
            score: post['counts']['score'],
            read: post['read'],
            saved: post['saved'],
          ),
        );
      }

      return posts;
    } on SocketException {
      return Future.error('No Internet');
    } on HttpException {
      return Future.error('Could not find post');
    } on FormatException {
      return Future.error('Bad response format');
    }
  }

  Future<List<LemmyComment>> getComments(String postId) async {
    try {
      final response = await client.get(
        Uri.https(
          'lemmy.ml',
          'api/v3/comment/list',
          {
            'post_id': postId,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      }

      var decodedResponse =
      (jsonDecode(utf8.decode(response.bodyBytes)) as Map)['comments'];

      List<LemmyComment> comments = [];

      for (final comment in decodedResponse) {
        comments.add(
            LemmyComment(
              creatorName: comment['creator']['name'],
                creatorId: comment['creator']['id'],
                content: comment['comment']['content'],
                id: comment['comment']['id'],
                postId: postId,
                childCount: comment['counts']['child_count'],
                upVotes: comment['counts']['upvotes'],
                downVotes: comment['counts']['downvotes'],
                score: comment['counts']['score'],
                hotRank: comment['counts']['hot_rank'])

        );
      }

      return comments;
    } on SocketException {
      return Future.error('No Internet');
    } on HttpException {
      return Future.error('Could not find post');
    } on FormatException {
      return Future.error('Bad response format');
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'lemmy/models.dart';

interface class LemmyApi {
  final Client client;

  LemmyApi() : client = Client();

  Future getPosts(
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
                post['post']['published'] + 'Z'), // Z added to mark as UTC time
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

  Future getComments(String postId) async {
    try{
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

    }on SocketException {
      return Future.error('No Internet');
    } on HttpException {
      return Future.error('Could not find post');
    } on FormatException {
      return Future.error('Bad response format');
    }

  }
}

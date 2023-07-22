import 'dart:io';

import 'lemmy/models.dart';
import 'package:dio/dio.dart';

interface class LemmyRepo {
  final Dio dio;
  final String baseUrl;

  LemmyRepo({this.baseUrl = 'https://lemmy.ml'}) : dio = Dio();

  Future<List<LemmyPost>> getPosts(
      {LemmySortType sortType = LemmySortType.hot,
      int page = 1,
      int? communityId}) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/v3/post/list',
        queryParameters: {
          'page': page.toString(),
          'sort': lemmySortTypeEnumToApiCompatible[sortType],
          if (communityId != null) 'community_id': communityId.toString(),
        },
      );

      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      }

      var postsMap = response.data['posts'];

      List<LemmyPost> posts = [];

      for (Map<String, dynamic> post in postsMap) {
        posts.add(
          LemmyPost(
            body: post['post']['body'],
            url: post['post']['url'],
            id: post['post']['id'],
            name: post['post']['name'],
            timePublished: DateTime.parse(post['post']['published'] + 'Z'),
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

  Future<List<LemmyComment>> getComments(int postId,
      {required int page}) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/v3/comment/list',
        queryParameters: {
          'post_id': postId.toString(),
          'page': page.toString(),
        },
      );

      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      }

      var commentsMap = response.data['comments'];

      // defines comment children and parent

      Map<int, List> mapReplyToParent = {};
      List<Map> baseLevelComments = [];

      for (final comment in commentsMap) {
        final String p = comment['comment']['path'];
        final List<String> parts = p.split('.');

        if (parts.length == 2) {
          baseLevelComments.add(comment);
        } else {
          final int parentId = int.parse(parts[parts.length - 2]);

          if (!mapReplyToParent.containsKey(parentId)) {
            mapReplyToParent[parentId] = [comment];
          } else {
            mapReplyToParent[parentId]!.add(comment);
          }
        }
      }

      LemmyComment mapToLemmyComment(
          Map<String, dynamic> comment, int level, int parentId) {
        final List<LemmyComment> replies = [];

        if (mapReplyToParent.containsKey(comment['comment']['id'])) {
          for (var element in mapReplyToParent[comment['comment']['id']]!) {
            replies.add(mapToLemmyComment(
                element, level + 1, comment['comment']['id']));
          }
        }

        return LemmyComment(
          parentCommentId: parentId,
          replies: replies,
          level: level + 1,
          creatorName: comment['creator']['name'],
          creatorId: comment['creator']['id'],
          content: comment['comment']['content'],
          id: comment['comment']['id'],
          timePublished: DateTime.parse(comment['comment']['published'] + 'Z'),
          // Z added to mark as UTC time
          postId: postId,
          childCount: comment['counts']['child_count'],
          upVotes: comment['counts']['upvotes'],
          downVotes: comment['counts']['downvotes'],
          score: comment['counts']['score'],
          hotRank: comment['counts']['hot_rank'],
        );
      }

      List<LemmyComment> comments = [];

      for (final comment in baseLevelComments) {
        final List<LemmyComment> replies = [];

        if (mapReplyToParent.containsKey(comment['comment']['id'])) {
          for (var element in mapReplyToParent[comment['comment']['id']]!) {
            replies
                .add(mapToLemmyComment(element, 1, comment['comment']['id']));
          }
        }

        comments.add(LemmyComment(
          level: 0,
          replies: replies,
          creatorName: comment['creator']['name'],
          creatorId: comment['creator']['id'],
          content: comment['comment']['content'],
          id: comment['comment']['id'],
          timePublished: DateTime.parse(comment['comment']['published'] + 'Z'),
          // Z added to mark as UTC time
          postId: postId,
          childCount: comment['counts']['child_count'],
          upVotes: comment['counts']['upvotes'],
          downVotes: comment['counts']['downvotes'],
          score: comment['counts']['score'],
          hotRank: comment['counts']['hot_rank'],
        ));
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

  Future<LemmySearchResponse> search({
    required String query,
    int page = 1,
    LemmySearchType searchType = LemmySearchType.all,
    LemmySortType sortType = LemmySortType.topAll,
    int? communityId,
    int? creatorId,
    LemmyListingType listingType = LemmyListingType.all,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/v3/search',
        queryParameters: {
          'q': query,
          'type_': lemmySearchTypeToApiCompatible[searchType],
          'sort': lemmySortTypeEnumToApiCompatible[sortType],
          if (communityId != null) 'community_id': communityId.toString(),
          if (creatorId != null) 'creator_id': creatorId.toString(),
          'listing_type': lemmyListingTypeToApiCompatible[listingType],
        },
      );

      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      }

      final List<LemmyComment> comments = [];
      final List<LemmyPerson> people = [];
      final List<LemmyPost> posts = [];
      final List<LemmyCommunity> communities = [];

      for (final comment in response.data['comments']) {
        comments.add(LemmyComment(
          creatorName: comment['creator']['name'],
          creatorId: comment['creator']['id'],
          content: comment['comment']['content'],
          id: comment['comment']['id'],
          timePublished: DateTime.parse(comment['comment']['published'] + 'Z'),
          // Z added to mark as UTC time
          postId: comment['comment']['post_id'],
          childCount: comment['counts']['child_count'],
          upVotes: comment['counts']['upvotes'],
          downVotes: comment['counts']['downvotes'],
          score: comment['counts']['score'],
          hotRank: comment['counts']['hot_rank'],
        ));
      }

      for (final person in response.data['users']) {
        people.add(LemmyPerson(
          actorId: person['person']['actor_id'],
          admin: person['person']['admin'],
          banned: person['person']['banned'],
          botAccount: person['person']['bot_account'],
          deleted: person['person']['deleted'],
          id: person['person']['id'],
          instanceId: person['person']['instance_id'],
          local: person['person']['local'],
          name: person['person']['name'],
          published: DateTime.parse(person['person']['published'] + 'Z'),
          commentCount: person['counts']['comment_count'],
          commentScore: person['counts']['comment_score'],
          postCount: person['counts']['post_count'],
          postScore: person['counts']['post_score'],
        ));
      }
      for (final post in response.data['posts']) {
        posts.add(
          LemmyPost(
            body: post['post']['body'],
            url: post['post']['url'],
            id: post['post']['id'],
            name: post['post']['name'],
            timePublished: DateTime.parse(post['post']['published'] + 'Z'),
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

      for (final community in response.data['communities']) {
        communities.add(LemmyCommunity(
          id: community['community']['id'],
          actorId: community['community']['actor_id'],
          deleted: community['community']['deleted'],
          hidden: community['community']['hidden'],
          name: community['community']['name'],
          local: community['community']['local'],
          instanceId: community['community']['instance_id'],
          nsfw: community['community']['nsfw'],
          postingRestrictedToMods: community['community']
              ['posting_restricted_to_mods'],
          published: DateTime.parse(community['community']['published'] + 'Z'),
          removed: community['community']['removed'],
          title: community['community']['title'],
          comments: community['counts']['comments'],
          hotRank: community['counts']['hot_rank'],
          posts: community['counts']['posts'],
          subscribers: community['counts']['subscribers'],
          usersActiveDay: community['counts']['users_active_day'],
          usersActiveHalfYear: community['counts']['users_active_half_year'],
          usersActiveMonth: community['counts']['users_active_month'],
          usersActiveWeek: community['counts']['users_active_week'],
          blocked: community['blocked'],
          subscribed:
              apiCompatibleToLemmySubscribedType[community['subscribed']]!,
          icon: community['community']['icon'],
          description: community['community']['description'],
          banner: community['community']['banner'],
        ));
      }

      return LemmySearchResponse(
        lemmyComments: comments,
        lemmyCommunities: communities,
        lemmyPersons: people,
        lemmyPosts: posts,
      );
    } on SocketException {
      return Future.error('No Internet');
    } on HttpException {
      return Future.error('Could not find post');
    } on FormatException {
      return Future.error('Bad response format');
    }
  }

  Future<LemmyCommunity> communityFromId(int id) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/v3/community',
        queryParameters: {
          'id': id.toString(),
        },
      );

      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      }

      var community = response.data['community_view'];

      return LemmyCommunity(
        id: community['community']['id'],
        actorId: community['community']['actor_id'],
        deleted: community['community']['deleted'],
        hidden: community['community']['hidden'],
        name: community['community']['name'],
        local: community['community']['local'],
        instanceId: community['community']['instance_id'],
        nsfw: community['community']['nsfw'],
        postingRestrictedToMods: community['community']
            ['posting_restricted_to_mods'],
        published: DateTime.parse(community['community']['published'] + 'Z'),
        removed: community['community']['removed'],
        title: community['community']['title'],
        comments: community['counts']['comments'],
        hotRank: community['counts']['hot_rank'],
        posts: community['counts']['posts'],
        subscribers: community['counts']['subscribers'],
        usersActiveDay: community['counts']['users_active_day'],
        usersActiveHalfYear: community['counts']['users_active_half_year'],
        usersActiveMonth: community['counts']['users_active_month'],
        usersActiveWeek: community['counts']['users_active_week'],
        blocked: community['blocked'],
        subscribed:
            apiCompatibleToLemmySubscribedType[community['subscribed']]!,
        icon: community['community']['icon'],
        description: community['community']['description'],
        banner: community['community']['banner'],
      );
    } on SocketException {
      return Future.error('No Internet');
    } on HttpException {
      return Future.error('Could not find post');
    } on FormatException {
      return Future.error('Bad response format');
    }
  }

  Future<LemmyLoginResponse> login(String password, String? totp,
      String usernameOrEmail, String serverAddr) async {

    print('username: $usernameOrEmail');
    print('password: $password');

    try {
      final response = await dio.post(
        'https://sh.itjust.works/api/v3/user/login',
        options: Options(headers: {'Content-type':'application/json'}),
        data: {
          'password': password,
          if (totp != null) 'totp_2fa_token': totp,
          'username_or_email': usernameOrEmail,
        },
      );

      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      }

      return LemmyLoginResponse(
          registrationCreated: response.data['registration_created'],
          verifyEmailSent: response.data['verify_email_sent'],
          jwt: response.data['jwt']);
    } on SocketException {
      return Future.error('No Internet');
    } on HttpException {
      return Future.error('Could not find post');
    } on FormatException {
      return Future.error('Bad response format');
    }
  }
}

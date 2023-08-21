import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/lemmy/models.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final _log = Logger('LemmyRepo');

/// Used to interact with the lemmy http api
interface class LemmyRepo {
  /// initialize lemmy repo
  LemmyRepo({required this.globalBloc})
      : dio = Dio()
          ..interceptors.add(
            PrettyDioLogger(
              logPrint: _log.finest,
            ),
          );

  /// The dio client that will be used to send requests
  final Dio dio;

  /// used to get information such as the home server to use for requests
  final GlobalBloc globalBloc;

  /// Creates a post request to the lemmy api
  Future<Map<String, dynamic>> postRequest(
      {required String path,
      Map<String, dynamic> data = const {},
      bool mustBeLoggedIn = true}) async {
    try {
      if (!globalBloc.isLoggedIn() && mustBeLoggedIn) {
        throw ('Not logged in');
      }

      final Response<Map<String, dynamic>> response = await dio.post(
        '${globalBloc.getLemmyBaseUrl()}/api/v3$path',
        data: {
          if (globalBloc.getSelectedLemmyAccount() != null)
            'auth': globalBloc.getSelectedLemmyAccount()!.jwt,
          ...data
        },
      );

      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      }

      if (response.data == null) {
        throw ('null returned in response');
      }

      return response.data!;
    } on SocketException {
      return Future.error('No Internet');
    } on HttpException {
      return Future.error('Could not find post');
    } on FormatException {
      return Future.error('Bad response format');
    }
  }

  /// Creates a get request to the lemmy api
  Future<Map<String, dynamic>> getRequest(
      {required String path,
      Map<String, dynamic> queryParameters = const {}}) async {
    final Map<String, dynamic> assembledQueryParameters = {
      if (globalBloc.getSelectedLemmyAccount() != null)
        'auth': globalBloc.getSelectedLemmyAccount()!.jwt,
      ...queryParameters
    };

    _log.info(
        'Sending get request to ${globalBloc.getLemmyBaseUrl()}, Path: $path, Data: $assembledQueryParameters');

    try {
      final Response<Map<String, dynamic>> response = await dio.get(
          '${globalBloc.getLemmyBaseUrl()}/api/v3$path',
          queryParameters: assembledQueryParameters);

      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      }

      if (response.data == null) {
        throw ('response returned null');
      }

      return response.data!;
    } on SocketException {
      return Future.error('No Internet');
    } on HttpException {
      return Future.error('Could not find post');
    } on FormatException {
      return Future.error('Bad response format');
    }
  }

  Future<List<LemmyPost>> getPosts({
    LemmySortType sortType = LemmySortType.hot,
    int page = 1,
    int? communityId,
    LemmyListingType listingType = LemmyListingType.all,
  }) async {
    final Map<String, dynamic> response =
        await getRequest(path: '/post/list', queryParameters: {
      'page': page,
      'sort': lemmySortTypeEnumToApiCompatible[sortType],
      if (communityId != null) 'community_id': communityId,
      'type_': lemmyListingTypeToApiCompatible[listingType],
    });

    final List<dynamic> rawPosts = response['posts'];

    final List<LemmyPost> posts = [];

    for (Map<String, dynamic> post in rawPosts) {
      posts.add(
        LemmyPost(
          body: (post['post'] as Map)['body'],
          url: (post['post'] as Map)['url'],
          id: (post['post'] as Map)['id'],
          name: (post['post'] as Map)['name'],
          myVote: intToLemmyVoteType[post['my_vote']] ?? LemmyVoteType.none,
          thumbnailUrl: (post['post'] as Map)['thumbnail_url'],
          apId: (post['post'] as Map)['ap_id'],
          // Z added to mark as UTC time
          timePublished:
              DateTime.parse('${(post['post'] as Map)['published']}Z'),
          nsfw: (post['post'] as Map)['nsfw'],
          creatorId: (post['post'] as Map)['creator_id'],
          creatorName: (post['creator'] as Map)['name'],
          communityId: (post['post'] as Map)['community_id'],
          communityName: (post['community'] as Map)['name'],
          communityIcon: (post['community'] as Map)['icon'],
          commentCount: (post['counts'] as Map)['comments'],
          upVotes: (post['counts'] as Map)['upvotes'],
          downVotes: (post['counts'] as Map)['downvotes'],
          score: (post['counts'] as Map)['score'],
          read: post['read'],
          saved: post['saved'],
        ),
      );
    }

    _log.fine('Retrieved posts: $posts');
    return posts;
  }

  /// Gets comments from lemmy api
  ///
  /// The lemmy api determines weather a comment is a child to another comment
  /// by a path value e.g. 0.356135.23532.234523, where the 0 is the post and
  /// the last number is the id the the comment itself
  ///
  /// the [LemmyComment] instead just has the child comments in a list in the
  /// object.
  ///
  /// Sometimes a comment can be returned from the api that does not include the
  /// parent comment in the list
  Future<List<LemmyComment>> getComments(
    int postId, {
    required int page,
    LemmyListingType listingType = LemmyListingType.all,
    LemmyCommentSortType sortType = LemmyCommentSortType.hot,
  }) async {
    final Map<String, dynamic> response =
        await getRequest(path: '/comment/list', queryParameters: {
      'post_id': postId.toString(),
      'page': page.toString(),
      'type_': lemmyListingTypeToApiCompatible[listingType],
      'sort': lemmyCommentSortTypeToApiCompatible[sortType],
    });

    final List<dynamic> rawComments = response['comments'];

    final List<LemmyComment> comments = [];

    for (final comment in rawComments) {
      final List<String> pathAsString =
          (comment['comment']['path'] as String).split('.');

      final List<int> path = [];
      for (int i = 0; i < pathAsString.length; i++) {
        if (i != 0 && i != pathAsString.length - 1) {
          path.add(int.parse(pathAsString[i]));
        }
      }

      comments.add(
        LemmyComment(
          page: page,
          myVote: intToLemmyVoteType[comment['my_vote']] ?? LemmyVoteType.none,
          path: path,
          creatorName: comment['creator']['name'],
          creatorId: comment['creator']['id'],
          content: comment['comment']['content'],
          timePublished: DateTime.parse(comment['comment']['published'] + 'Z'),
          id: comment['comment']['id'],
          postId: postId,
          childCount: comment['counts']['child_count'],
          upVotes: comment['counts']['upvotes'],
          downVotes: comment['counts']['downvotes'],
          score: comment['counts']['score'],
          hotRank: comment['counts']['hot_rank'],
        ),
      );
    }

    return comments;
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
    final response = await getRequest(path: '/search', queryParameters: {
      'page': page,
      'q': query,
      'type_': lemmySearchTypeToApiCompatible[searchType],
      'sort': lemmySortTypeEnumToApiCompatible[sortType],
      if (communityId != null) 'community_id': communityId.toString(),
      if (creatorId != null) 'creator_id': creatorId.toString(),
      'listing_type': lemmyListingTypeToApiCompatible[listingType],
    });

    final List<LemmyComment> comments = [];
    final List<LemmyPerson> people = [];
    final List<LemmyPost> posts = [];
    final List<LemmyCommunity> communities = [];

    for (final comment in response['comments']) {
      final List<String> pathAsString =
          (comment['comment']['path'] as String).split('.');

      final List<int> path = [];
      for (int i = 0; i < pathAsString.length; i++) {
        if (i != 0 && i != pathAsString.length - 1) {
          path.add(int.parse(pathAsString[i]));
        }
      }

      comments.add(
        LemmyComment(
          path: path,
          creatorName: comment['creator']['name'],
          creatorId: comment['creator']['id'],
          content: comment['comment']['content'],
          id: comment['comment']['id'],
          page: page,
          // Z added to mark as UTC time
          timePublished: DateTime.parse(comment['comment']['published'] + 'Z'),

          postId: comment['comment']['post_id'],
          childCount: comment['counts']['child_count'],
          upVotes: comment['counts']['upvotes'],
          downVotes: comment['counts']['downvotes'],
          score: comment['counts']['score'],
          myVote: intToLemmyVoteType[comment['my_vote']] ?? LemmyVoteType.none,
          hotRank: comment['counts']['hot_rank'],
        ),
      );
    }

    for (final person in response['users']) {
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
    for (final post in response['posts']) {
      posts.add(
        LemmyPost(
          body: post['post']['body'],
          url: post['post']['url'],
          id: post['post']['id'],
          apId: post['post']['ap_id'],
          name: post['post']['name'],
          // Z added to mark as UTC time
          timePublished: DateTime.parse(post['post']['published'] + 'Z'),
          myVote: intToLemmyVoteType[post['my_vote']] ?? LemmyVoteType.none,
          thumbnailUrl: post['post']['thumbnail_url'],
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

    for (final community in response['communities']) {
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
  }

  Future<LemmyCommunity> getCommunity({int? id, String? name}) async {
    if (id == null && name == null) {
      throw ('Both community id and name are not provided');
    }

    final response = await getRequest(path: '/community', queryParameters: {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });

    final rawCommunity = response['community_view'];

    return LemmyCommunity(
      id: rawCommunity['community']['id'],
      actorId: rawCommunity['community']['actor_id'],
      deleted: rawCommunity['community']['deleted'],
      hidden: rawCommunity['community']['hidden'],
      name: rawCommunity['community']['name'],
      local: rawCommunity['community']['local'],
      instanceId: rawCommunity['community']['instance_id'],
      nsfw: rawCommunity['community']['nsfw'],
      postingRestrictedToMods: rawCommunity['community']
          ['posting_restricted_to_mods'],
      published: DateTime.parse(rawCommunity['community']['published'] + 'Z'),
      removed: rawCommunity['community']['removed'],
      title: rawCommunity['community']['title'],
      comments: rawCommunity['counts']['comments'],
      hotRank: rawCommunity['counts']['hot_rank'],
      posts: rawCommunity['counts']['posts'],
      subscribers: rawCommunity['counts']['subscribers'],
      usersActiveDay: rawCommunity['counts']['users_active_day'],
      usersActiveHalfYear: rawCommunity['counts']['users_active_half_year'],
      usersActiveMonth: rawCommunity['counts']['users_active_month'],
      usersActiveWeek: rawCommunity['counts']['users_active_week'],
      blocked: rawCommunity['blocked'],
      subscribed:
          apiCompatibleToLemmySubscribedType[rawCommunity['subscribed']]!,
      icon: rawCommunity['community']['icon'],
      description: rawCommunity['community']['description'],
      banner: rawCommunity['community']['banner'],
    );
  }

  Future<LemmyLoginResponse> login(String password, String? totp,
      String usernameOrEmail, String serverAddr) async {
    final Map<String, dynamic> response = await postRequest(
        path: '/user/login',
        data: {
          'username_or_email': usernameOrEmail,
          'password': password,
          if (totp != null) 'totp_2fa_token': totp,
        },
        mustBeLoggedIn: false);

    return LemmyLoginResponse(
        registrationCreated: response['registration_created'],
        verifyEmailSent: response['verify_email_sent'],
        jwt: response['jwt']);
  }

  Future<void> votePost(
    int postId,
    LemmyVoteType vote,
  ) =>
      postRequest(path: '/post/like', data: {
        'post_id': postId,
        'score': lemmyVoteTypeToApiCompatible[vote],
      });

  Future<void> voteComment(
    int commentId,
    LemmyVoteType vote,
  ) =>
      postRequest(path: '/comment/like', data: {
        'comment_id': commentId,
        'score': lemmyVoteTypeToApiCompatible[vote],
      });

  Future<void> createComment(
    String content,
    int postId,
    int? parentId,
  ) =>
      postRequest(path: '/comment', data: {
        'post_id': postId,
        'content': content,
        if (parentId != null) 'parent_id': parentId,
      });
}

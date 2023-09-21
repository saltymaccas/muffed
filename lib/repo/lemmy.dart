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

  /// Creates a post request to the lemmy api, If logged in auth parameter will
  /// be added automatically
  Future<Map<String, dynamic>> postRequest({
    required String path,
    Map<String, dynamic> data = const {},
    bool mustBeLoggedIn = true,
    String? serverAddress,
  }) async {
    try {
      if (!globalBloc.isLoggedIn() && mustBeLoggedIn) {
        throw Exception('Not logged in');
      }

      final Response<Map<String, dynamic>> response = await dio.post(
        '${serverAddress ?? globalBloc.getLemmyBaseUrl()}/api/v3$path',
        data: {
          if (globalBloc.getSelectedLemmyAccount() != null && mustBeLoggedIn)
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

  /// Sends a get request to the lemmy api, If logged in auth parameter will be
  /// added automatically
  Future<Map<String, dynamic>> getRequest(
      {required String path,
      Map<String, dynamic> queryParameters = const {},
      bool mustBeLoggedIn = false}) async {
    if (mustBeLoggedIn && !globalBloc.isLoggedIn()) {
      throw Exception('Not logged in');
    }

    _log.info(
        'Sending get request to ${globalBloc.getLemmyBaseUrl()}, Path: $path, Data: $queryParameters');

    try {
      final Response<Map<String, dynamic>> response = await dio.get(
        '${globalBloc.getLemmyBaseUrl()}/api/v3$path',
        queryParameters: {
          if (globalBloc.getSelectedLemmyAccount() != null)
            'auth': globalBloc.getSelectedLemmyAccount()!.jwt,
          ...queryParameters,
        },
      );

      if (response.data == null) {
        throw ('response returned null');
      }

      return response.data!;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<List<LemmyPost>> getPosts({
    LemmySortType sortType = LemmySortType.hot,
    int page = 1,
    int? communityId,
    LemmyListingType listingType = LemmyListingType.all,
  }) async {
    final Map<String, dynamic> response = await getRequest(
      path: '/post/list',
      queryParameters: {
        'page': page,
        'sort': lemmySortTypeToJson[sortType],
        if (communityId != null) 'community_id': communityId,
        'type_': lemmyListingTypeToJson[listingType],
      },
    );

    final List<dynamic> jsonPosts = response['posts'];

    return List.generate(
      jsonPosts.length,
      (index) => LemmyPost.fromPostViewJson(jsonPosts[index]),
    );
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
  Future<List<LemmyComment>> getComments({
    int? postId,
    int? parentId,
    int page = 1,
    int? limit = 50,
    LemmyListingType listingType = LemmyListingType.all,
    LemmyCommentSortType sortType = LemmyCommentSortType.hot,
  }) async {
    if (parentId == null && postId == null) {
      throw ('No id provided');
    }

    final Map<String, dynamic> response = await getRequest(
      path: '/comment/list',
      queryParameters: {
        if (postId != null) 'post_id': postId,
        if (parentId != null) 'parent_id': parentId,
        if (limit != null) 'limit': limit,
        'page': page,
        'type_': lemmyListingTypeToJson[listingType],
        'sort': lemmyCommentSortTypeToJson[sortType],
        'max_depth': 8,
      },
    );

    final List<dynamic> rawComments = response['comments'];

    return List.generate(rawComments.length,
        (index) => LemmyComment.fromCommentViewJson(rawComments[index]));
  }

  Future<LemmyGetPersonDetailsResponse> getPersonDetails({
    int? id,
    String? username,
    int page = 1,
    LemmySortType? sortType,
  }) async {
    if (id == null && username == null) {
      throw ('Both id and username equals null');
    }
    final response = await getRequest(
      path: '/user',
      queryParameters: {
        if (id != null) 'person_id': id,
        if (username != null) 'username': username,
        'page': page,
        'sort':
            lemmySortTypeToJson[sortType ?? globalBloc.state.defaultSortType],
      },
    );

    return LemmyGetPersonDetailsResponse(
      person: LemmyPerson.fromPersonViewJson(response['person_view']),
      posts: List.generate(
        (response['posts'] as List).length,
        (index) => LemmyPost.fromPostViewJson(
          (response['posts'] as List)[index],
        ),
      ),
      comments: List.generate(
        (response['comments'] as List).length,
        (index) => LemmyComment.fromCommentViewJson(
          (response['comments'] as List)[index],
        ),
      ),
      moderates: List.generate((response['moderates'] as List).length,
          (index) => response['moderates'][index]['community']['title']),
    );
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
    final response = await getRequest(
      path: '/search',
      queryParameters: {
        'page': page,
        'q': query,
        'type_': lemmySearchTypeToJson[searchType],
        'sort': lemmySortTypeToJson[sortType],
        if (communityId != null) 'community_id': communityId.toString(),
        if (creatorId != null) 'creator_id': creatorId.toString(),
        'listing_type': lemmyListingTypeToJson[listingType],
      },
    );

    final List<dynamic> rawComments = response['comments'];
    final List<dynamic> rawCommunities = response['communities'];
    final List<dynamic> rawPersons = response['users'];
    final List<dynamic> rawPosts = response['posts'];

    return LemmySearchResponse(
      lemmyComments: List.generate(
        rawComments.length,
        (index) => LemmyComment.fromCommentViewJson(rawComments[index]),
      ),
      lemmyCommunities: List.generate(
        rawCommunities.length,
        (index) => LemmyCommunity.fromCommunityViewJson(rawCommunities[index]),
      ),
      lemmyPersons: List.generate(
        rawPersons.length,
        (index) => LemmyPerson.fromPersonViewJson(rawPersons[index]),
      ),
      lemmyPosts: List.generate(
        rawPosts.length,
        (index) => LemmyPost.fromPostViewJson(rawPosts[index]),
      ),
    );
  }

  Future<LemmyCommunity> getCommunity({int? id, String? name}) async {
    if (id == null && name == null) {
      throw ('Both community id and name are not provided');
    }

    final response = await getRequest(
      path: '/community',
      queryParameters: {
        if (id != null) 'id': id,
        if (name != null) 'name': name,
      },
    );

    return LemmyCommunity.fromCommunityViewJson(response['community_view']);
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
        mustBeLoggedIn: false,
        serverAddress: serverAddr);

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
        'score': lemmyVoteTypeJson[vote],
      });

  Future<void> voteComment(
    int commentId,
    LemmyVoteType vote,
  ) =>
      postRequest(path: '/comment/like', data: {
        'comment_id': commentId,
        'score': lemmyVoteTypeJson[vote],
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

  Future<LemmySubscribedType> followCommunity({
    required int communityId,
    required bool follow,
  }) async {
    final response = await postRequest(
      path: '/community/follow',
      data: {'community_id': communityId, 'follow': follow},
    );

    return jsonToLemmySubscribedType[response['community_view']['subscribed']]!;
  }

  /// Used to block and unblock a person, returns whether the user is now
  /// blocked
  Future<bool> BlockPerson({required int personId, required bool block}) async {
    final response = await postRequest(
        path: '/user/block',
        data: {
          'block': block,
          'person_id': personId,
        },
        mustBeLoggedIn: true);
    return response['blocked'];
  }

  Future<bool> getIsPersonBlocked(int personId) async {
      final response = await getRequest(path: '/site', mustBeLoggedIn: true);

      for (final block in response['my_user']['person_blocks']) {
        if (block['target']['id'] == personId) {
          return true;
        }
      }

      return false;

  }

  /// User to block and unblock a community, returns whether the community is
  /// now blocked
  Future<bool> BlockCommunity({required int id, required bool block}) async {
    final response = await postRequest(
      path: '/community/block',
      data: {'community_id': id, 'block': block},
      mustBeLoggedIn: true,
    );
    return response['blocked'];
  }

  Future<bool> getIsCommunityBlocked(int communityId) async {
    final response = await getRequest(path: '/site', mustBeLoggedIn: true);

    for (final block in response['my_user']['community_blocks']) {
      if (block['community']['id'] == communityId) {
        return true;
      }
    }

    return false;
  }
}

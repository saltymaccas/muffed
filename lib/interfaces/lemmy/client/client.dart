import 'package:flutter/material.dart';
import 'package:lemmy_api_client/pictrs.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/db/db.dart';
import 'package:muffed/db/models/auth.dart';

final class LemmyClient {
  LemmyClient(BuildContext context) : _db = DB.of(context);

  final DB _db;

  LemmyApiV3 get lem => LemmyApiV3(_db.state.auth.lemmy.activeHost);
  PictrsApi get pic => PictrsApi(_db.state.auth.lemmy.activeHost);

  LemmyAuthRepository get key => _db.state.auth.lemmy;
  String? get jwt => key.jwt;

  Future<GetPostsResponse> getPosts({
    ListingType? type,
    SortType? sort,
    int? page,
    int? limit,
    int? communityId,
    String? communityName,
    bool? savedOnly,
    bool? likedOnly,
    bool? dislikedOnly,
    String? pageCursor,
  }) =>
      lem.run(
        GetPosts(
          auth: jwt,
          communityId: communityId,
          sort: sort,
          communityName: communityName,
          dislikedOnly: dislikedOnly,
          savedOnly: savedOnly,
          page: page,
          limit: limit,
          likedOnly: likedOnly,
          pageCursor: pageCursor,
          type: type,
        ),
      );

  Future<GetCommentsResponse> getComments({
    CommentSortType? sort,
    int? maxDepth,
    int? page,
    int? limit,
    int? communityId,
    String? communityName,
    int? postId,
    int? parentId,
    bool? savedOnly,
    bool? likedOnly, // Only available in lemmy v0.19.0 and above
    bool? dislikedOnly,
  }) =>
      lem.run(
        GetComments(
          auth: jwt,
          communityId: communityId,
          sort: sort,
          communityName: communityName,
          dislikedOnly: dislikedOnly,
          savedOnly: savedOnly,
          page: page,
          limit: limit,
          likedOnly: likedOnly,
          postId: postId,
          parentId: parentId,
          maxDepth: maxDepth,
        ),
      );

  Future<GetPersonDetailsResponse> getPersonDetails({
    int? personId,
    String? username,
    SortType? sort,
    int? page,
    int? limit,
    int? communityId,
    bool? savedOnly,
  }) =>
      lem.run(
        GetPersonDetails(
          auth: jwt,
          personId: personId,
          username: username,
          sort: sort,
          page: page,
          limit: limit,
          communityId: communityId,
          savedOnly: savedOnly,
        ),
      );

  Future<SearchResponse> search({
    required String q,
    String? query,
    int? communityId,
    String? communityName,
    int? creatorId,
    SearchType? type,
    SortType? sort,
    ListingType? listingType,
    int? page,
    int? limit,
  }) =>
      lem.run(
        Search(
          auth: jwt,
          q: q,
          communityId: communityId,
          communityName: communityName,
          creatorId: creatorId,
          type: type,
          sort: sort,
          listingType: listingType,
          page: page,
          limit: limit,
        ),
      );

  Future<GetCommunityResponse> getCommunity({
    int? id,
    String? name,
  }) =>
      lem.run(
        GetCommunity(
          auth: jwt,
          id: id,
          name: name,
        ),
      );

  Future<LoginResponse> login({
    required String usernameOrEmail,
    required String password,
    String? totp2faToken,
  }) =>
      lem.run(
        Login(
          usernameOrEmail: usernameOrEmail,
          password: password,
          totp2faToken: totp2faToken,
        ),
      );

  Future<PostResponse> createPostLike({
    required int postId,
    required num score,
  }) =>
      lem.run(
        CreatePostLike(
          auth: jwt,
          score: score,
          postId: 1,
        ),
      );

  Future<CommentResponse> createCommentLike({
    required int commentId,
    required num score,
  }) =>
      lem.run(CreateCommentLike(auth: jwt, commentId: commentId, score: score));

  Future<CommentResponse> createComment({
    required String content,
    required int postId,
    int? parentId,
    int? languageId,
  }) =>
      lem.run(CreateComment(
          auth: jwt,
          content: content,
          postId: postId,
          parentId: parentId,
          languageId: languageId));

  Future<CommunityResponse> followCommunity({
    required int communityId,
    required bool follow,
  }) =>
      lem.run(
          FollowCommunity(auth: jwt, communityId: communityId, follow: follow));

  Future<BlockPersonResponse> blockPerson({
    required int personId,
    required bool block,
  }) =>
      lem.run(BlockPerson(auth: jwt, personId: personId, block: block));

  Future<BlockCommunityResponse> blockCommunity({
    required int communityId,
    required bool block,
  }) =>
      lem.run(
          BlockCommunity(auth: jwt, communityId: communityId, block: block));

  Future<PostResponse> savePost({
    required int postId,
    required bool save,
  }) =>
      lem.run(SavePost(auth: jwt, postId: postId, save: save));

  Future<GetSiteResponse> getSite() => lem.run(GetSite(auth: jwt));

  Future<GetSiteMetadataResponse> getSiteMetadata({required String url}) =>
      lem.run(GetSiteMetadata(url: url));

  Future<PostResponse> createPost({
    required String name,
    required int communityId,
    String? url,
    String? body,
    String? honeypot,
    bool? nsfw,
    int? languageId,
    String? auth,
  }) =>
      lem.run(
        CreatePost(
          auth: jwt,
          name: name,
          communityId: communityId,
          url: url,
          body: body,
          honeypot: honeypot,
          nsfw: nsfw,
          languageId: languageId,
        ),
      );

  Future<GetRepliesResponse> getReplies({
    CommentSortType? sort,
    int? page,
    int? limit,
    bool? unreadOnly,
  }) =>
      lem.run(
        GetReplies(
          auth: jwt,
          unreadOnly: unreadOnly,
          page: page,
          limit: limit,
          sort: sort,
        ),
      );

  Future<GetPersonMentionsResponse> getPersonMentions({
    CommentSortType? sort,
    int? page,
    int? limit,
    bool? unreadOnly,
  }) =>
      lem.run(GetPersonMentions(
        auth: jwt,
        unreadOnly: unreadOnly,
        page: page,
        limit: limit,
        sort: sort,
      ));

  Future<CommentReplyResponse> markCommentReplyAsRead({
    required int commentReplyId,
    required bool read,
  }) =>
      markCommentReplyAsRead(commentReplyId: commentReplyId, read: read);

  Future<PersonMentionResponse> markPersonMentionAsRead({
    required int personMentionId,
    required bool read,
  }) =>
      lem.run(MarkPersonMentionAsRead(
          personMentionId: personMentionId, read: read));

  Future<GetPostResponse> getPost({
    int? id,
    int? commentId,
  }) =>
      lem.run(GetPost(auth: jwt, id: id, commentId: commentId));

  Future<PostResponse> editPost({
    required int postId,
    String? name,
    String? url,
    String? body,
    bool? nsfw,
    int? languageId,
    String? auth,
  }) =>
      lem.run(EditPost(
          auth: jwt,
          postId: postId,
          name: name,
          url: url,
          body: body,
          nsfw: nsfw,
          languageId: languageId));

  Future<CommentResponse> editComment({
    required int commentId,
    String? content,
    int? languageId,
    String? auth,
  }) =>
      lem.run(EditComment(
        auth: jwt,
        commentId: commentId,
        content: content,
        languageId: languageId,
      ));

  Future<PictrsUpload> uploadImage({
    required String filePath,
  }) =>
      pic.upload(filePath: filePath);

      Future<void> deleteImage(PictrsUploadFile pictrsFile) => pic.delete(pictrsFile);
}

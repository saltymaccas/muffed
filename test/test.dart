import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/lemmy/models.dart';

void main() {
  test('GlobalState should convert to map and back', () {
    final globalState = GlobalState(
        lemmySelectedAccount: 1,
        themeMode: ThemeMode.light,
        seedColor: Colors.red.shade50,
        showNsfw: true,
        blurNsfw: false,
        lemmyAccounts: [
          LemmyAccountData(
            userName: 'testUser',
            homeServer: 'test.home.server',
            jwt: 'test.jwt',
          ),
          LemmyAccountData(
            userName: 'testUser1',
            homeServer: 'test.home.server1',
            jwt: 'test.jwt1',
          ),
        ],
        defaultSortType: LemmySortType.latest);

    final globalStateToMap = globalState.toMap();

    final globalStateFromMap = GlobalState.fromMap(globalStateToMap);

    expect(globalStateFromMap, globalState);
  });
  test('LemmyComment should add reply', () {
    final LemmyComment comment = LemmyComment(
      page: 1,
      path: [],
      creatorName: 'creatorName',
      creatorId: 1,
      content: 'content',
      timePublished: DateTime.fromMillisecondsSinceEpoch(100000000),
      id: 1,
      postId: 12,
      childCount: 12,
      upVotes: 2,
      downVotes: 2,
      score: 2,
      hotRank: 2,
      replies: [
        LemmyComment(
          page: 1,
          path: [1],
          creatorName: 'creatorName',
          creatorId: 2,
          content: 'content',
          timePublished: DateTime.fromMillisecondsSinceEpoch(100000000),
          id: 2,
          replies: [
            LemmyComment(
              page: 1,
              path: [1, 2],
              creatorName: 'creatorName',
              creatorId: 2,
              content: 'content',
              timePublished: DateTime.fromMillisecondsSinceEpoch(100000000),
              id: 3,
              postId: 12,
              childCount: 12,
              upVotes: 2,
              downVotes: 2,
              score: 2,
              hotRank: 2,
            ),
          ],
          postId: 12,
          childCount: 12,
          upVotes: 2,
          downVotes: 2,
          score: 2,
          hotRank: 2,
        ),
        LemmyComment(
          page: 1,
          path: [1],
          creatorName: 'creatorName',
          creatorId: 2,
          content: 'content',
          timePublished: DateTime.fromMillisecondsSinceEpoch(100000000),
          id: 12,
          postId: 12,
          childCount: 12,
          upVotes: 2,
          downVotes: 2,
          score: 2,
          hotRank: 2,
        ),
      ],
    );

    final LemmyComment comment2 = LemmyComment(
      page: 1,
      path: [1, 2, 3],
      creatorName: 'creatorName',
      creatorId: 3,
      content: 'content',
      timePublished: DateTime.fromMillisecondsSinceEpoch(100000000),
      id: 4,
      postId: 12,
      childCount: 12,
      upVotes: 2,
      downVotes: 2,
      score: 2,
      hotRank: 2,
    );

    bool value = comment.addCommentToTree(comment2);

    expect(comment.replies[0].replies[0].replies[0], comment2);
    expect(value, true);
  });
}

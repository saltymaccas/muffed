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
      bodyTextScaleFactor: 23,
      labelTextScaleFactor: 23,
      lemmyDefaultHomeServer: 'test.home.server',
      titleTextScaleFactor: 23,
      useDynamicColorScheme: false,
      lemmyAccounts: const [
        LemmyAccountData(
          id: 12,
          name: 'testUser',
          homeServer: 'test.home.server',
          jwt: 'test.jwt',
        ),
        LemmyAccountData(
          id: 13,
          name: 'testUser1',
          homeServer: 'test.home.server1',
          jwt: 'test.jwt1',
        ),
      ],
      defaultSortType: LemmySortType.latest,
    );

    final globalStateToMap = globalState.toMap();

    final globalStateFromMap = GlobalState.fromMap(globalStateToMap);

    expect(globalStateFromMap, globalState);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:muffed/global_state/bloc.dart';

void main() {
  test('GlobalState should convert to map and back', () {
    final globalState = GlobalState(lemmySelectedAccount: 1, lemmyAccounts: [
      LemmyAccountData(
          userName: 'testUser',
          homeServer: 'test.home.server',
          jwt: 'test.jwt'),
      LemmyAccountData(
        userName: 'testUser1',
        homeServer: 'test.home.server1',
        jwt: 'test.jwt1',
      )
    ]);

    final globalStateToMap = globalState.toMap();

    final globalStateFromMap = GlobalState.fromMap(globalStateToMap);

    expect(globalState == globalStateFromMap, true);
  });
}

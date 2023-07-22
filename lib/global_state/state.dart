part of 'bloc.dart';

final class GlobalState extends Equatable {
  final List<LemmyAccountData> lemmyAccounts;

  /// the index of the selected account on lemmyAccounts
  /// null mean anonymous/no account
  final int? lemmySelectedAccount;

  /// the home server used if no account selected
  final String lemmyDefaultHomeServer;

  GlobalState({
    this.lemmyAccounts = const [],
    this.lemmySelectedAccount,
    this.lemmyDefaultHomeServer = 'lemmy.ml',
  });

  @override
  List<Object?> get props => [
        lemmyAccounts,
        lemmySelectedAccount,
        lemmyDefaultHomeServer,
      ];

  Map<String, dynamic> toMap() {
    return {
      'accounts': List.generate(this.lemmyAccounts.length,
          (index) => this.lemmyAccounts[index].toMap()),
      'lemmySelectedAccount': this.lemmySelectedAccount,
      'lemmyDefaultHomeServer': this.lemmyDefaultHomeServer,
    };
  }

  factory GlobalState.fromMap(Map<String, dynamic> map) {
    return GlobalState(
        lemmyAccounts: List.generate((map['lemmyAccounts'] as List).length,
            (index) => LemmyAccountData.fromMap(map['lemmyAccounts'][index])),
        lemmySelectedAccount: map['lemmySelectedAccount'] as int?,
        lemmyDefaultHomeServer: map['lemmyDefaultHome']);
  }

  GlobalState copyWith({
    List<LemmyAccountData>? lemmyAccounts,
    int? lemmySelectedAccount,
    String? lemmyDefaultHomeServer,
  }) {
    return GlobalState(
      lemmyDefaultHomeServer:
          lemmyDefaultHomeServer ?? this.lemmyDefaultHomeServer,
      lemmyAccounts: lemmyAccounts ?? this.lemmyAccounts,
      lemmySelectedAccount: lemmySelectedAccount ?? this.lemmySelectedAccount,
    );
  }
}

final class LemmyAccountData {
  final String jwt;
  final String homeServer;
  final String userName;

  LemmyAccountData(
      {required this.jwt, required this.homeServer, required this.userName});

  Map<String, dynamic> toMap() {
    return {
      'jwt': this.jwt,
      'homeServer': this.homeServer,
      'userName': this.userName,
    };
  }

  factory LemmyAccountData.fromMap(Map<String, dynamic> map) {
    return LemmyAccountData(
      jwt: map['jwt'] as String,
      homeServer: map['homeServer'] as String,
      userName: map['userName'] as String,
    );
  }
}

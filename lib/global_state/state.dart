part of 'bloc.dart';

final class GlobalState extends Equatable {
  final List<AccountData> lemmyAccounts;

  // null means anonymous/no account
  final int? lemmySelectedAccount;

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
            (index) => AccountData.fromMap(map['lemmyAccounts'][index])),
        lemmySelectedAccount: map['lemmySelectedAccount'] as int?,
        lemmyDefaultHomeServer: map['lemmyDefaultHome']);
  }

  GlobalState copyWith({
    List<AccountData>? lemmyAccounts,
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

final class AccountData {
  final String jwt;
  final String homeServer;
  final String userName;

  AccountData(
      {required this.jwt, required this.homeServer, required this.userName});

  Map<String, dynamic> toMap() {
    return {
      'jwt': this.jwt,
      'homeServer': this.homeServer,
      'userName': this.userName,
    };
  }

  factory AccountData.fromMap(Map<String, dynamic> map) {
    return AccountData(
      jwt: map['jwt'] as String,
      homeServer: map['homeServer'] as String,
      userName: map['userName'] as String,
    );
  }
}

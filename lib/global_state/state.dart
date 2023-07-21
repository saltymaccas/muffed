part of 'bloc.dart';

final class GlobalState extends Equatable {
  final List<AccountData> accounts;
  final int? selectedAccount;

  GlobalState({this.accounts = const [], this.selectedAccount});

  @override
  List<Object?> get props => [accounts, selectedAccount];

  Map<String, dynamic> toMap() {
    return {
      'accounts': List.generate(
          this.accounts.length, (index) => this.accounts[index].toMap()),
      'selectedAccount': this.selectedAccount
    };
  }

  factory GlobalState.fromMap(Map<String, dynamic> map) {
    return GlobalState(
      accounts: List.generate((map['accounts'] as List).length,
          (index) => AccountData.fromMap(map['accounts'][index])),
      selectedAccount: map['selectedAccount'] as int?,
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

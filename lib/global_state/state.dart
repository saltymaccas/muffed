part of 'bloc.dart';

class GlobalState extends Equatable {
  final Map<String, String?> accounts;
  final String selectedAccount;

  GlobalState({this.accounts = const {'anonymous': null}, this.selectedAccount = 'anonymous'});

  @override
  List<Object?> get props => [accounts, selectedAccount];

  Map<String, dynamic> toMap() {
    return {
      'accounts': this.accounts,
      'selectedAccount' : this.selectedAccount
    };
  }

  factory GlobalState.fromMap(Map<String, dynamic> map) {
    return GlobalState(
      accounts: map['accounts'] as Map<String, String?>,
      selectedAccount: map['selectedAccount'] as String,
    );
  }
}

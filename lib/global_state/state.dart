part of 'bloc.dart';

final class GlobalState extends Equatable {
  ///
  const GlobalState({
    this.themeMode = ThemeMode.system,
    this.lemmyAccounts = const [],
    this.lemmySelectedAccount = -1,
    this.lemmyDefaultHomeServer = 'https://lemmy.ml',
    this.useDynamicColorScheme = true,
    this.seedColor = Colors.blueGrey,
  });

  factory GlobalState.fromMap(Map<String, dynamic> map) {
    return GlobalState(
      lemmyAccounts: List.generate(
        (map['lemmyAccounts'] as List).length,
        (index) => LemmyAccountData.fromMap(map['lemmyAccounts'][index]),
      ),
      lemmySelectedAccount: map['lemmySelectedAccount'] as int,
      lemmyDefaultHomeServer: map['lemmyDefaultHomeServer'],
      themeMode: ThemeMode.values[map['themeMode']],
      useDynamicColorScheme: map['useDynamicColorScheme'] as bool,
      seedColor: Color(map['seedColor'] as int),
    );
  }

  /// All the lemmy accounts the user has added
  final List<LemmyAccountData> lemmyAccounts;

  /// the index of the selected account on lemmyAccounts
  /// -1 mean anonymous/no account
  final int lemmySelectedAccount;

  /// the home server used if no account selected
  final String lemmyDefaultHomeServer;

  /// Whether the app is in dark or light mode
  final ThemeMode themeMode;

  final bool useDynamicColorScheme;

  /// The color used to generate the apps color scheme
  final Color seedColor;

  @override
  List<Object?> get props => [
        lemmyAccounts,
        lemmySelectedAccount,
        lemmyDefaultHomeServer,
        themeMode,
        useDynamicColorScheme,
    seedColor,
      ];

  Map<String, dynamic> toMap() {
    return {
      'lemmyAccounts': List.generate(
        this.lemmyAccounts.length,
        (index) => this.lemmyAccounts[index].toMap(),
      ),
      'lemmySelectedAccount': this.lemmySelectedAccount,
      'lemmyDefaultHomeServer': this.lemmyDefaultHomeServer,
      'themeMode': this.themeMode.index,
      'useDynamicColorScheme': this.useDynamicColorScheme,
      'seedColor': seedColor.value,
    };
  }

  GlobalState copyWith({
    List<LemmyAccountData>? lemmyAccounts,
    int? lemmySelectedAccount,
    String? lemmyDefaultHomeServer,
    ThemeMode? themeMode,
    bool? useDynamicColorScheme,
    Color? seedColor,
  }) {
    return GlobalState(
      lemmyDefaultHomeServer:
          lemmyDefaultHomeServer ?? this.lemmyDefaultHomeServer,
      lemmyAccounts: lemmyAccounts ?? this.lemmyAccounts,
      lemmySelectedAccount: lemmySelectedAccount ?? this.lemmySelectedAccount,
      themeMode: themeMode ?? this.themeMode,
      useDynamicColorScheme:
          useDynamicColorScheme ?? this.useDynamicColorScheme,
      seedColor: seedColor ?? this.seedColor,
    );
  }
}

final class LemmyAccountData extends Equatable {
  LemmyAccountData(
      {required this.jwt, required this.homeServer, required this.userName});

  factory LemmyAccountData.fromMap(Map<String, dynamic> map) {
    return LemmyAccountData(
      jwt: map['jwt'] as String,
      homeServer: map['homeServer'] as String,
      userName: map['userName'] as String,
    );
  }

  final String jwt;

  /// home server should include the "https://" and not end with "/"
  final String homeServer;
  final String userName;

  Map<String, dynamic> toMap() {
    return {
      'jwt': this.jwt,
      'homeServer': this.homeServer,
      'userName': this.userName,
    };
  }

  @override
  List<Object?> get props => [
        jwt,
        homeServer,
        userName,
      ];
}

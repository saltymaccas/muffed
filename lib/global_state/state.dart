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
    this.showNsfw = false,
    this.blurNsfw = true,
    this.defaultSortType = LemmySortType.active,
    this.bodyTextScaleFactor = 1.0,
    this.labelTextScaleFactor = 1.0,
    this.titleTextScaleFactor = 1.0,
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
      showNsfw: map['showNsfw'],
      blurNsfw: map['blurNsfw'],
      defaultSortType: LemmySortType.values[map['defaultSortType']],
      bodyTextScaleFactor: map['bodyTextScaleFactor'],
      labelTextScaleFactor: map['labelTextScaleFactor'],
      titleTextScaleFactor: map['titleTextScaleFactor'],
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

  /// whether to show or hide nsfw posts
  final bool showNsfw;

  /// whether to blur nsfw posts
  final bool blurNsfw;

  final LemmySortType defaultSortType;

  final double bodyTextScaleFactor;
  final double labelTextScaleFactor;
  final double titleTextScaleFactor;

  bool get isLoggedIn => lemmySelectedAccount != -1;

  LemmyAccountData? get selectedLemmyAccount {
    return (lemmySelectedAccount == -1)
        ? null
        : lemmyAccounts[lemmySelectedAccount];
  }

  String get lemmyBaseUrl => (lemmySelectedAccount == -1)
      ? lemmyDefaultHomeServer
      : lemmyAccounts[lemmySelectedAccount].homeServer.toString();

  String get currentLemmyEndPointIdentifyer =>
      '$lemmyBaseUrl${selectedLemmyAccount?.jwt.split('.').last}';

  /// if the content the app gets may be different
  ///
  /// Used in content scroll view to see whether the posts should be reloaded
  bool lemmyRequestEndPointDifferent(GlobalState state) {
    if (state.lemmyBaseUrl != lemmyBaseUrl ||
        state.selectedLemmyAccount?.jwt != selectedLemmyAccount?.jwt) {
      return true;
    }
    return false;
  }

  @override
  List<Object?> get props => [
        lemmyAccounts,
        lemmySelectedAccount,
        lemmyDefaultHomeServer,
        themeMode,
        useDynamicColorScheme,
        seedColor,
        showNsfw,
        blurNsfw,
        defaultSortType,
        bodyTextScaleFactor,
        labelTextScaleFactor,
        titleTextScaleFactor,
      ];

  Map<String, dynamic> toMap() {
    return {
      'lemmyAccounts': List.generate(
        lemmyAccounts.length,
        (index) => lemmyAccounts[index].toMap(),
      ),
      'lemmySelectedAccount': lemmySelectedAccount,
      'lemmyDefaultHomeServer': lemmyDefaultHomeServer,
      'themeMode': themeMode.index,
      'useDynamicColorScheme': useDynamicColorScheme,
      'seedColor': seedColor.value,
      'showNsfw': showNsfw,
      'blurNsfw': blurNsfw,
      'defaultSortType': defaultSortType.index,
      'bodyTextScaleFactor': bodyTextScaleFactor,
      'labelTextScaleFactor': labelTextScaleFactor,
      'titleTextScaleFactor': titleTextScaleFactor,
    };
  }

  GlobalState copyWith({
    List<LemmyAccountData>? lemmyAccounts,
    int? lemmySelectedAccount,
    String? lemmyDefaultHomeServer,
    ThemeMode? themeMode,
    bool? useDynamicColorScheme,
    Color? seedColor,
    bool? showNsfw,
    bool? blurNsfw,
    LemmySortType? defaultSortType,
    double? bodyTextScaleFactor,
    double? labelTextScaleFactor,
    double? titleTextScaleFactor,
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
      showNsfw: showNsfw ?? this.showNsfw,
      blurNsfw: blurNsfw ?? this.blurNsfw,
      defaultSortType: defaultSortType ?? this.defaultSortType,
      bodyTextScaleFactor: bodyTextScaleFactor ?? this.bodyTextScaleFactor,
      labelTextScaleFactor: labelTextScaleFactor ?? this.labelTextScaleFactor,
      titleTextScaleFactor: titleTextScaleFactor ?? this.titleTextScaleFactor,
    );
  }
}

final class LemmyAccountData extends Equatable {
  const LemmyAccountData({
    required this.jwt,
    required this.homeServer,
    required this.name,
    required this.id,
  });

  factory LemmyAccountData.fromMap(Map<String, dynamic> map) {
    return LemmyAccountData(
      jwt: map['jwt'] as String,
      homeServer: HttpUrl.fromMap(map['homeServer']),
      name: map['userName'] as String,
      id: map['id'] as int,
    );
  }

  final String jwt;

  final HttpUrl homeServer;
  final String name;

  final int id;

  Map<String, dynamic> toMap() {
    return {
      'jwt': jwt,
      'homeServer': homeServer.toMap(),
      'userName': name,
      'id': id,
    };
  }

  @override
  List<Object?> get props => [
        jwt,
        homeServer,
        name,
        id,
      ];
}

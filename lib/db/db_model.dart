part of 'db.dart';

@JsonSerializable()
final class DBModel extends Equatable {
  const DBModel({
    this.authRepository = const AuthRepository(
      currentLemmyAuthKey: 0,
      lemmyAuthKeys: [
        LemmyAnonAuthKey(url: 'sh.itjust.works', name: 'Anonymous', id: 0),
      ],
    ),
    this.appLook = const AppLookModel(
      bodyTextScaleFactor: 1,
      labelTextScaleFactor: 1,
      titleTextScaleFactor: 1,
      colorSchemeMode: ThemeMode.system,
      seedColor: Colors.greenAccent,
      wallBasedColorScheme: true,
    ),
  });

  factory DBModel.fromMap(Map<String, dynamic> json) =>
      _$DBModelFromJson(json);

  final AuthRepository authRepository;
  final AppLookModel appLook;

  Map<String, dynamic> toMap() => _$DBModelToJson(this);

  @override
  List<Object?> get props => [
        authRepository,
        appLook,
      ];
}

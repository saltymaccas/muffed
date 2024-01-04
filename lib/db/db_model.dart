part of 'db.dart';

@JsonSerializable()
final class DBModel extends Equatable {
  const DBModel({
    this.auth = const AuthRepository(
      lemmy: LemmyAuthRepository(
        keys: [
          LemmyAnonAuthKey(url: 'sh.itjust.works', name: 'Anonymous', id: 0),
        ],
        activeKeyIndex: 0,
      ),
    ),
    this.look = const ThemeConfig(
      bodyTextScaleFactor: 1,
      labelTextScaleFactor: 1,
      titleTextScaleFactor: 1,
      colorSchemeMode: ThemeMode.system,
      seedColor: Colors.greenAccent,
      wallBasedColorScheme: true,
    ),
  });

  factory DBModel.fromMap(Map<String, dynamic> json) => _$DBModelFromJson(json);

  final AuthRepository auth;
  final ThemeConfig look;

  Map<String, dynamic> toMap() => _$DBModelToJson(this);

  @override
  List<Object?> get props => [
        auth,
        look,
      ];
}

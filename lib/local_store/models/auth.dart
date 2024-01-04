import 'package:equatable/equatable.dart';
import 'package:muffed/repo/lemmy/models/user.dart';

final class AuthRepository extends Equatable {
  const AuthRepository({
    required this.lemmyAuthKeys,
    required this.currentLemmyAuthKey,
  });

  final List<LemmyAuthKey> lemmyAuthKeys;
  final int currentLemmyAuthKey;

  @override
  List<Object?> get props => [
        lemmyAuthKeys,
        currentLemmyAuthKey,
      ];
}

final class LemmyAuthKey extends Equatable {
  const LemmyAuthKey({
    required this.url,
  });
  final String url;

  @override
  List<Object?> get props => [
        url,
      ];
}

final class LemmyAnonAuthKey extends LemmyAuthKey {
  const LemmyAnonAuthKey({
    required super.url,
    required this.name,
    required this.id,
  });

  // Local only, the user chooses and can change the name
  final String name;

  // Unique id, local only, user cant see or change
  final int id;

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        id,
      ];
}

final class LemmyUserAuthKey extends LemmyAuthKey {
  const LemmyUserAuthKey({
    required super.url,
    required this.jwt,
    this.userInfo,
  });

  final String jwt;
  final LemmyUserAuthInfo? userInfo;

  @override
  List<Object?> get props => [
        ...super.props,
        jwt,
        userInfo,
      ];
}

final class LemmyUserAuthInfo extends Equatable {
  const LemmyUserAuthInfo({
    required this.name,
    required this.id,
    this.displayName,
    this.avatar,
    this.banner,
  });

  final String name;
  final int id;
  final String? displayName;
  final String? avatar;
  final String? banner;

  @override
  List<Object?> get props => [
        name,
        id,
        displayName,
        banner,
        avatar,
      ];
}

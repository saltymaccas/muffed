import 'package:equatable/equatable.dart';

class LemmyLanguage extends Equatable {
  const LemmyLanguage({
    required this.code,
    required this.id,
    required this.name,
  });

  LemmyLanguage.fromLanguage(Map<String, dynamic> json)
      : code = json['code'],
        id = json['id'],
        name = json['name'];

  final String code;
  final int id;
  final String name;

  @override
  List<Object?> get props => [
        code,
        id,
        name,
      ];
}

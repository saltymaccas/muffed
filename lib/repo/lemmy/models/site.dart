import 'package:equatable/equatable.dart';

import 'package:muffed/repo/lemmy/models/models.dart';

class LemmySite extends Equatable {
  const LemmySite({
    required this.admins,
    required this.languages,
    required this.discussionLanguages,
    required this.version,
    required this.id,
    required this.instanceId,
    required this.name,
    required this.published,
    this.banner,
    this.description,
    this.icon,
    this.privateKey,
    this.publicKey,
    this.sidebar,
    this.updated,
  });

  LemmySite.fromGetSiteResponse(Map<String, dynamic> json)
      : admins = List.generate(
          json['admins'].length,
          (index) => LemmyUser.fromJson(json['admins'][index]),
        ),
        languages = List.generate(
          json['all_languages'].length,
          (index) => LemmyLanguage.fromLanguage(json['all_languages'][index]),
        ),
        discussionLanguages = List.generate(
          json['discussion_languages'].length,
          (index) => json['discussion_languages'][index],
        ),
        version = json['version'],
        banner = json['site_view']['site']['banner'],
        description = json['site_view']['site']['description'],
        icon = json['site_view']['site']['icon'],
        id = json['site_view']['site']['id'],
        instanceId = json['site_view']['site']['instance_id'],
        name = json['site_view']['site']['name'],
        privateKey = json['site_view']['site']['private_key'],
        publicKey = json['site_view']['site']['public_key'],
        published =
            DateTime.parse('${json['site_view']['site']['published']}Z'),
        sidebar = json['site_view']['site']['sidebar'],
        updated = DateTime.parse('${json['site_view']['site']['updated']}Z');

  final List<LemmyUser> admins;
  final List<LemmyLanguage> languages;
  final List<int> discussionLanguages;
  final String version;

  // site
  final String? banner;
  final String? description;
  final String? icon;
  final int id;
  final int instanceId;
  final String name;
  final String? privateKey;
  final String? publicKey;
  final DateTime published;
  final String? sidebar;
  final DateTime? updated;

  @override
  List<Object?> get props => [
        admins,
        languages,
        discussionLanguages,
        version,
        banner,
        description,
        icon,
        id,
        instanceId,
        name,
        privateKey,
        publicKey,
        published,
        sidebar,
        updated,
      ];
}

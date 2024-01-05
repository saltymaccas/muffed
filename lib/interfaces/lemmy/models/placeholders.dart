import 'package:lemmy_api_client/v3.dart';

final communityPlaceHolder = Community.fromJson({
  "id": 250203,
  "name": "muffed",
  "title": "muffed for lemmy",
  "description":
      "An open source Lemmy client written in flutter with a focus on usability and privacy.\n\nhttps://github.com/freshfieldreds/muffed",
  "removed": false,
  "published": "2023-09-23T10:20:28.671041",
  "updated": "2023-10-22T22:44:32.603287",
  "deleted": false,
  "nsfw": false,
  "actor_id": "https://sh.itjust.works/c/muffed",
  "local": true,
  "icon":
      "https://sh.itjust.works/pictrs/image/7298bb7e-cfea-479f-9e9d-0ca90a2f7866.webp",
  "hidden": false,
  "posting_restricted_to_mods": false,
  "instance_id": 1
});

final communityViewPlaceHolder = CommunityView.fromJson({
    "community": {
      "id": 250203,
      "name": "muffed",
      "title": "muffed for lemmy",
      "description": "An open source Lemmy client written in flutter with a focus on usability and privacy.\n\nhttps://github.com/freshfieldreds/muffed",
      "removed": false,
      "published": "2023-09-23T10:20:28.671041",
      "updated": "2023-10-22T22:44:32.603287",
      "deleted": false,
      "nsfw": false,
      "actor_id": "https://sh.itjust.works/c/muffed",
      "local": true,
      "icon": "https://sh.itjust.works/pictrs/image/7298bb7e-cfea-479f-9e9d-0ca90a2f7866.webp",
      "hidden": false,
      "posting_restricted_to_mods": false,
      "instance_id": 1
    },
    "subscribed": "NotSubscribed",
    "blocked": false,
    "counts": {
      "id": 13993,
      "community_id": 250203,
      "subscribers": 53,
      "posts": 10,
      "comments": 17,
      "published": "2023-09-23T10:20:28.671041",
      "users_active_day": 1,
      "users_active_week": 1,
      "users_active_month": 1,
      "users_active_half_year": 10,
      "hot_rank": 0
    }
  });

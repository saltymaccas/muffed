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

final postPlaceHolder = PostView.fromJson({
    "post": {
      "id": 5716352,
      "name": "Announcing Muffed for Lemmy - An open source Lemmy client written in flutter",
      "body": "Muffed is an open source Lemmy client written in flutter with a focus on usability and privacy. \n\nCurrently Muffed is in very early development and may be missing some features\n\n**Download now from the Github repo:** https://github.com/freshfieldreds/muffed\n\n*currently only compiled for android, IOS support will be coming soon*",
      "creator_id": 3726303,
      "community_id": 250203,
      "removed": false,
      "locked": false,
      "published": "2023-09-23T10:41:41.254290",
      "deleted": false,
      "nsfw": false,
      "ap_id": "https://sh.itjust.works/post/5716352",
      "local": true,
      "language_id": 0,
      "featured_community": false,
      "featured_local": false
    },
    "creator": {
      "id": 3726303,
      "name": "freshfieldreds",
      "avatar": "https://sh.itjust.works/pictrs/image/d22d3707-70d0-4821-834a-b86ef31550bb.webp",
      "banned": false,
      "published": "2023-09-23T09:44:07.421167",
      "actor_id": "https://sh.itjust.works/u/freshfieldreds",
      "local": true,
      "deleted": false,
      "admin": false,
      "bot_account": false,
      "instance_id": 1
    },
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
    "creator_banned_from_community": false,
    "counts": {
      "id": 645951,
      "post_id": 5716352,
      "comments": 2,
      "score": 13,
      "upvotes": 13,
      "downvotes": 0,
      "published": "2023-09-23T10:41:41.254290",
      "newest_comment_time_necro": "2023-09-23T15:27:44.799287",
      "newest_comment_time": "2023-09-23T15:27:44.799287",
      "featured_community": false,
      "featured_local": false,
      "hot_rank": 0,
      "hot_rank_active": 0,
      "community_id": 250203,
      "creator_id": 3726303
    },
    "subscribed": "NotSubscribed",
    "saved": false,
    "read": false,
    "creator_blocked": false,
    "unread_comments": 2
  },
  );

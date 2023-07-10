import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:muffed/components/loading.dart';
import 'package:server_api/lemmy/models.dart';
import 'package:muffed/utils/utils.dart';
import '../post_more_actions_sheet/post_more_actions_sheet.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:muffed/home_page/post_view/card.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen(this.post, {super.key});

  final LemmyPost post;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            elevation: 2,
            floating: true,
            title: Text('Comments'),
          )
        ];
      },
      body: RefreshIndicator(
        onRefresh: () async {},
        child: NotificationListener(
          onNotification: (ScrollNotification scrollInfo) {return true;},
          child: ListView.builder(
              cacheExtent: 100000,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CardLemmyPostItem(post, limitContentHeight: false,);
                }
              }),
        ),
      ),
    );
  }
}

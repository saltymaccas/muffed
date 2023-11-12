import 'package:flutter/material.dart';
import 'package:muffed/components/markdown_body.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/lemmy/models.dart';

class CommunityInfoScreen extends StatelessWidget {
  const CommunityInfoScreen({required this.community, super.key});

  final LemmyCommunity community;

  @override
  Widget build(BuildContext context) {
    return SetPageInfo(
      actions: [],
      page: Pages.home,
      child: Scaffold(
        appBar: AppBar(
          title: Text(community.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (community.description != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: MuffedMarkdownBody(
                    data: community.description!,
                  ),
                ),
              const Divider(),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

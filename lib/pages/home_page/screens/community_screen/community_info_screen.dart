import 'package:flutter/material.dart';
import 'package:muffed/components/markdown_body.dart';

import '../../../../repo/lemmy/models.dart';

class CommunityInfoScreen extends StatelessWidget {
  const CommunityInfoScreen({required this.community, super.key});

  final LemmyCommunity community;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(community.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (community.description != null)
              MuffedMarkdownBody(
                data: community.description!,
              ),
          ],
        ),
      ),
    );
  }
}

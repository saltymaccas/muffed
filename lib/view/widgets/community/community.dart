import 'package:flutter/material.dart';
import 'package:muffed/domain/lemmy/models.dart';
import 'package:muffed/view/pages/community_screen/community_screen.dart';
import 'package:muffed/view/widgets/muffed_avatar.dart';

class CommunityListTile extends StatelessWidget {
  const CommunityListTile(
    this.community, {
    super.key,
  });

  final LemmyCommunity community;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => CommunityScreen()),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  child: MuffedAvatar(
                    url: community.icon,
                    radius: 16,
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${community.subscribers}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                            ),
                            TextSpan(
                              text: ' members ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      if (community.description != null)
                        Text(
                          community.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

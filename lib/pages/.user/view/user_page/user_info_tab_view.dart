part of 'user_page.dart';

class _UserInfoTabView extends StatelessWidget {
  _UserInfoTabView({LemmyUser? user})
      : usingPlaceHolderData = user == null,
        user = user ?? LemmyUser.placeHolder();

  final LemmyUser user;
  final bool usingPlaceHolderData;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: usingPlaceHolderData,
      child: CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              const SizedBox(
                height: _headerMinHeight,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Flexible(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user.postCount.toString(),
                              textAlign: TextAlign.center,
                              style: context.textTheme.displaySmall,
                            ),
                            Text(
                              'Posts',
                              style: context.textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user.commentCount.toString(),
                              textAlign: TextAlign.center,
                              style: context.textTheme.displaySmall,
                            ),
                            Text(
                              'Comments',
                              style: context.textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              if (user.bio != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: MuffedMarkdownBody(data: user.bio!),
                ),
              const SizedBox(
                height: 8,
              ),
              Container(
                color: Theme.of(context).colorScheme.surfaceVariant,
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Moderates (${user.moderates!.length})',
                  style: context.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          SliverList.builder(
            itemCount: user.moderates!.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: MuffedAvatar(
                  url: user.moderates![index].icon,
                  identiconID: user.moderates![index].name,
                  radius: 16,
                ),
                title: Text(
                  user.moderates![index].name,
                ),
                onTap: () {
                  context.pushPage(
                    CommunityPage(
                      communityName: user.moderates![index].name,
                      communityId: user.moderates![index].id,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

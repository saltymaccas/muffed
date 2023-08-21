import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:muffed/components/snackbars.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';

import '../utils/time.dart';

class LemmyCommunityCard extends StatefulWidget {
  const LemmyCommunityCard({super.key, required this.community});

  final LemmyCommunity community;

  @override
  State<LemmyCommunityCard> createState() => _LemmyCommunityCardState();
}

class _LemmyCommunityCardState extends State<LemmyCommunityCard> {
  late LemmySubscribedType subscribedType;

  bool isLoadingSubscribe = false;

  @override
  void initState() {
    subscribedType = widget.community.subscribed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _log = Logger('CommunityCard: ${widget.community.name}');

    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          context.push('/home/community?id=${widget.community.id}');
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            image: (widget.community.banner != null)
                ? DecorationImage(
                    image: CachedNetworkImageProvider(
                      widget.community.banner!,
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.5,
                  )
                : null,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(45),
                      child: (widget.community.icon != null)
                          ? CachedNetworkImage(imageUrl: widget.community.icon!)
                          : SvgPicture.asset(
                              'assets/logo.svg',
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Text(
                      widget.community.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 8,
                runSpacing: 8,
                children: [
                  InfoChip(
                    label: Text('Age'),
                    value: Text(formattedPostedAgo(widget.community.published)),
                  ),
                  InfoChip(
                    label: Text('Posts'),
                    value: Text(widget.community.posts.toString()),
                  ),
                  InfoChip(
                    label: Text('Subscribers'),
                    value: Text(widget.community.subscribers.toString()),
                  ),
                  InfoChip(
                    label: Text('Hot Rank'),
                    value: Text(widget.community.hotRank.toString()),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              if (context.read<GlobalBloc>().isLoggedIn())
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () async {
                      try {
                        final result = await context
                            .read<ServerRepo>()
                            .lemmyRepo
                            .followCommunity(
                                communityId: widget.community.id,
                                follow: subscribedType ==
                                    LemmySubscribedType.notSubscribed);

                        _log.info('Subscribe results: $result');

                        setState(() {
                          subscribedType = result;
                        });
                      } catch (err) {
                        _log.warning(err);
                        showErrorSnackBar(context, text: err.toString());
                      }
                    },
                    style: (subscribedType == LemmySubscribedType.notSubscribed)
                        ? TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          )
                        : TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.outline,
                            foregroundColor:
                                Theme.of(context).colorScheme.outlineVariant,
                          ),
                    child: (subscribedType == LemmySubscribedType.subscribed)
                        ? Text('Unsubscribe')
                        : (subscribedType == LemmySubscribedType.notSubscribed)
                            ? Text('Subscribe')
                            : Text('Pending'),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class LemmyPersonCard extends StatelessWidget {
  const LemmyPersonCard({required this.person, super.key});

  final LemmyPerson person;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            image: (person.banner != null)
                ? DecorationImage(
                    image: CachedNetworkImageProvider(
                      person.banner!,
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.5,
                  )
                : null,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(45),
                      child: (person.avatar != null)
                          ? CachedNetworkImage(imageUrl: person.avatar!)
                          : SvgPicture.asset(
                              'assets/logo.svg',
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Text(
                      person.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 8,
                runSpacing: 8,
                children: [
                  InfoChip(
                    label: Text('Age'),
                    value: Text(formattedPostedAgo(person.published)),
                  ),
                  InfoChip(
                    label: Text('Post Score'),
                    value: Text(person.postScore.toString()),
                  ),
                  InfoChip(
                    label: Text('Comment Score'),
                    value: Text(person.commentScore.toString()),
                  ),
                  InfoChip(
                    label: Text('Post Count'),
                    value: Text(person.postCount.toString()),
                  ),
                  InfoChip(
                    label: Text('Comment Count'),
                    value: Text(person.commentCount.toString()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  const InfoChip({
    super.key,
    required this.label,
    required this.value,
  });

  final Widget label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      elevation: 2,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.labelMedium!,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: label,
            ),
            Container(
              //color: Theme.of(context).colorScheme.outline,
              width: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: value,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/domain/lemmy_keychain/bloc.dart';

class KeyCard extends StatelessWidget {
  KeyCard({
    required LemmyKey lemKey,
    this.onDeletePressed,
    this.site,
    this.slim = false,
    this.markAsSelected = false,
    super.key,
    this.onTap,
  })  : instanceAddress = lemKey.instanceAddress,
        authenticated = lemKey.authToken != null;

  final String instanceAddress;
  final bool authenticated;
  final bool slim;
  final bool markAsSelected;
  final void Function()? onTap;
  final GetSiteResponse? site;
  final void Function()? onDeletePressed;

  double get aspectRatio {
    if (slim) {
      return 4 / 1;
    } else {
      return 3.37 / 2.125;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        side: markAsSelected
            ? BorderSide(
                color: theme.primaryColor,
                width: 4,
              )
            : BorderSide.none,
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Builder(
            builder: (context) {
              if (site == null) {
                return _UnloadedKeyCard(
                  instanceAddress: instanceAddress,
                  authenticated: authenticated,
                  onDeletePressed: onDeletePressed,
                );
              }
              return const Placeholder();
            },
          ),
        ),
      ),
    );
  }
}

class _LoadedKeyCard extends StatelessWidget {
  const _LoadedKeyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _UnloadedKeyCard extends StatelessWidget {
  const _UnloadedKeyCard({
    required this.instanceAddress,
    required this.authenticated,
    required this.onDeletePressed,
    super.key,
  });

  final String instanceAddress;
  final bool authenticated;
  final void Function()? onDeletePressed;

  String get authStatusText {
    if (authenticated) {
      return '(authenticated)';
    } else {
      return '(not authenticated)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final instanceAddressTextStyle =
        theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold);
    final userTextTheme =
        theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.outline);
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              authStatusText,
              style: userTextTheme,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(instanceAddress, style: instanceAddressTextStyle),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(icon: Icon(Icons.delete), onPressed: onDeletePressed),
          ],
        ),
      ],
    );
  }
}

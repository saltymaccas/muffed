import 'package:flutter/material.dart';
import 'package:muffed/domain/lemmy_keychain/bloc.dart';

class KeyCard extends StatelessWidget {
  KeyCard({
    required LemmyKey lemKey,
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
              if (authenticated) {
                return _AuthenticatedCard();
              } else {
                return _UnauthenticatedCard(
                  instanceAddress: instanceAddress,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _AuthenticatedCard extends StatelessWidget {
  const _AuthenticatedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _UnauthenticatedCard extends StatelessWidget {
  const _UnauthenticatedCard({required this.instanceAddress, super.key});

  final String instanceAddress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final instanceAddressTextStyle =
        theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold);
    final userTextTheme =
        theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.outline);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '(unauthenticated)',
          style: userTextTheme,
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(instanceAddress, style: instanceAddressTextStyle),
        ),
      ],
    );
  }
}

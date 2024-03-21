import 'package:flutter/material.dart';
import 'package:muffed/view/widgets/muffed_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentHeader extends StatelessWidget {
  const CommentHeader({
    required this.creatorName,
    required this.creationTime,
    this.creatorIcon,
    this.onCreatorTap,
    super.key,
  });

  final String creatorName;
  final String? creatorIcon;
  final DateTime creationTime;

  final void Function()? onCreatorTap;

  double get height => 25;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final creatorNameTextStyle =
        theme.textTheme.labelMedium!.copyWith(color: theme.colorScheme.primary);

    final publishedTextStyle =
        theme.textTheme.labelMedium!.copyWith(color: theme.colorScheme.outline);

    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onCreatorTap,
            child: Row(
              children: [
                if (creatorIcon != null)
                  MuffedAvatar(radius: 10, url: creatorName),
                if (creatorIcon != null) const SizedBox(width: 4),
                Text(
                  creatorName,
                  style: creatorNameTextStyle,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child:
                Text(timeago.format(creationTime), style: publishedTextStyle),
          ),
        ],
      ),
    );
  }
}

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MuffedAvatar extends StatelessWidget {
  const MuffedAvatar({this.url, super.key, this.radius = 24});

  /// The url to the avatar, if null will use placeholder
  final String? url;

  /// The radius of the avatar
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      foregroundImage:
          (url != null) ? ExtendedNetworkImageProvider(url!) : null,
      backgroundImage: const ExtendedAssetImageProvider(
        'assets/logo.png',
      ),
    );
  }
}

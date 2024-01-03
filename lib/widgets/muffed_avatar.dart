import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:muffed/widgets/image.dart';

class MuffedAvatar extends StatelessWidget {
  const MuffedAvatar({this.url, this.identiconID, super.key, this.radius = 24});

  /// The url to the avatar, if null will use placeholder
  final String? url;

  final String? identiconID;

  /// The radius of the avatar
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      foregroundImage: (url != null || identiconID != null)
          ? ExtendedNetworkImageProvider(
              url ?? 'https://github.com/identicons/$identiconID.png',
              cache: true,
            )
          : Image.asset('assets/logo.png').image,
    );
  }
}

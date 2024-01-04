import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MuffedAvatar extends StatelessWidget {
  const MuffedAvatar({this.url, this.identiconID, this.radius, this.minRadius, this.maxRadius, super.key});

  /// The url to the avatar, if null will use placeholder
  final String? url;

  final String? identiconID;

  final double? radius;

  final double? minRadius;
  final double? maxRadius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      minRadius: minRadius,
      maxRadius: maxRadius,
      foregroundImage: (url != null || identiconID != null)
          ? ExtendedNetworkImageProvider(
              url ?? 'https://github.com/identicons/$identiconID.png',
              cache: true,
            )
          : Image.asset('assets/logo.png').image,
    );
  }
}

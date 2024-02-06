import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:muffed/view/widgets/image.dart';

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
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(radius),
        child: (url != null)
            ? MuffedImage(
                fullScreenable: false,
                fit: BoxFit.cover,
                imageUrl: url!,
              )
            : ExtendedImage.asset(
                'assets/logo.png',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:muffed/components/image_viewer.dart';
import 'package:muffed/utils/measure_size.dart';

/// Displays an image from a url
class MuffedImage extends StatefulWidget {
  ///
  const MuffedImage({
    required this.imageUrl,
    required this.shouldBlur,
    this.numOfRetries = 3,
    super.key,
  });

  /// The url of the image
  final String imageUrl;

  /// Whether the image should be initially blured
  final bool shouldBlur;

  /// The number of tries the widget will take to load the image
  final int numOfRetries;

  @override
  State<MuffedImage> createState() => _MuffedImageState();
}

class _MuffedImageState extends State<MuffedImage> {
  double? height;
  late bool shouldBlur;

  @override
  void initState() {
    shouldBlur = widget.shouldBlur;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget generateImage({int num = 0}) {
      return CachedNetworkImage(
        imageUrl: widget.imageUrl,
        errorWidget: (num < widget.numOfRetries)
            ? (context, url, err) {
                return generateImage(num: num + 1);
              }
            : null,
        imageBuilder: (context, imageProvider) {
          final UniqueKey heroTag = UniqueKey();
          return GestureDetector(
            // if should blur is on a tap should remove the blur and a
            // second tap should open the image
            onTap: (!shouldBlur)
                ? () {
                    openImageViewer(
                      context,
                      imageProvider,
                      heroTag,
                      DisposeLevel.low,
                    );
                  }
                : null,

            child: MeasureSize(
              onChange: (size) {
                setState(() {
                  height = size.height;
                });
              },
              child: ClipRect(
                child: ImageFiltered(
                  enabled: shouldBlur,
                  imageFilter: ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10,
                  ),
                  child: Hero(
                    tag: heroTag,
                    child: Image(
                      image: imageProvider,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        placeholder: (context, url) {
          // width is double.maxFinite to make image not animate the
          // width changing size but instead only animate the height
          return const SizedBox(
            height: 300,
            width: double.maxFinite,
          );
        },
      );
    }

    return GestureDetector(
      onTap: shouldBlur
          ? () {
              setState(() {
                shouldBlur = false;
              });
            }
          : null,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        child: SizedBox(
          height: height,
          child: generateImage(),
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:muffed/utils/measure_size.dart';

final _log = Logger('MuffedImageViewer');

/// Displays an image from a url
class MuffedImage extends StatefulWidget {
  ///
  const MuffedImage({
    required this.imageUrl,
    this.shouldBlur = false,
    this.animateSizeChange = true,
    this.numOfRetries = 3,
    this.initialHeight = 300,
    super.key,
  });

  /// The url of the image
  final String imageUrl;

  /// Whether the image should be initially blured
  final bool shouldBlur;

  /// The number of tries the widget will take to load the image
  final int numOfRetries;

  /// The size the widget will take up before the image loads
  final double initialHeight;

  /// whether to animate the height of the widget changing when the image laods
  final bool animateSizeChange;

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
                _log
                  ..info('Failed to load image with error: $err')
                  ..info(
                    'Retrying, attempt $num...',
                  );

                return generateImage(num: num + 1);
              }
            : null,
        imageBuilder: (context, imageProvider) {
          final UniqueKey heroTag = UniqueKey();
          return GestureDetector(
            // if should blur is on a tap should remove the blur and a
            // second tap should open the image
            onTap: (!shouldBlur)
                ? null
                : () {
                    setState(() {
                      shouldBlur = false;
                    });
                  },

            child: MeasureSize(
              onChange: (size) {
                setState(() {
                  height = size.height;
                });
              },
              child: ClipRect(
                child: ImageFiltered(
                  enabled: shouldBlur,
                  imageFilter: ImageFilter.compose(
                    inner: ImageFilter.blur(
                      sigmaX: 35,
                      sigmaY: 35,
                    ),
                    outer: ImageFilter.erode(
                      radiusX: 10,
                      radiusY: 10,
                    ),
                  ),
                  child: Image(
                    image: imageProvider,
                  ),
                ),
              ),
            ),
          );
        },
        progressIndicatorBuilder: (context, url, downloadProgress) {
          // width is double.maxFinite to make image not animate the
          // width changing size but instead only animate the height
          return SizedBox(
            height: widget.initialHeight,
            width: double.maxFinite,
            child: Align(
              alignment: Alignment.topCenter,
              child: (downloadProgress.progress != null)
                  ? LinearProgressIndicator(
                      value: downloadProgress.progress,
                    )
                  : null,
            ),
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
      child: (widget.animateSizeChange)
          ? AnimatedSize(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
              child: SizedBox(
                height: height,
                child: generateImage(),
              ),
            )
          : SizedBox(
              height: height,
              child: generateImage(),
            ),
    );
  }
}

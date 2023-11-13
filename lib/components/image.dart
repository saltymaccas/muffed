import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:muffed/utils/measure_size.dart';
import 'package:photo_view/photo_view.dart';

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
    this.tapAnywhereForFullScreen = true,
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

  /// whether to show an icon button to open the image in full screen or
  /// image tap to open full screen
  final bool tapAnywhereForFullScreen;

  @override
  State<MuffedImage> createState() => _MuffedImageState();
}

class _MuffedImageState extends State<MuffedImage> {
  double? height;
  late bool shouldBlur;
  late String heroTag;

  @override
  void initState() {
    shouldBlur = widget.shouldBlur;
    heroTag = DateTime.now().microsecondsSinceEpoch.toString();

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
              child: Stack(
                children: [
                  ClipRect(
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
                      child: Hero(
                        tag: heroTag,
                        child: Image(
                          image: imageProvider,
                        ),
                      ),
                    ),
                  ),
                  if (!widget.tapAnywhereForFullScreen && false)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: IconButton(
                          iconSize: 30,
                          style: IconButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0.8),
                          ),
                          onPressed: () {
                            showFullScreenImageView(
                              context,
                              widget.imageUrl,
                              heroTag,
                            );
                          },
                          icon: const Icon(Icons.fullscreen),
                        ),
                      ),
                    ),
                ],
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
          : widget.tapAnywhereForFullScreen
              ? () {
                  showFullScreenImageView(
                    context,
                    widget.imageUrl,
                    heroTag,
                  );
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

// the below code was taken and modified from https://github.com/liftoff-app/liftoff/blob/3055896657ef05772dc5fa18c5b3ab285b93f54a/lib/pages/media_view.dart#L166

void showFullScreenImageView(BuildContext context, String url, String heroTag) {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (context) => FullScreenImageView(url: url, heroTag: heroTag),
    ),
  );
}

class FullScreenImageView extends StatefulWidget {
  const FullScreenImageView(
      {required this.url, required this.heroTag, super.key,});

  final String url;
  final String heroTag;

  @override
  State<FullScreenImageView> createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView> {
  final yThreshold = 150;
  final speedThreshold = 45;

  bool showButtons = true;
  bool isZoomedOut = true;

  bool scaleIsInitial = true;
  bool isDragging = false;

  Offset offset = Offset.zero;
  Offset prevOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Listener(
        onPointerMove: scaleIsInitial
            ? (event) {
                if (!isDragging && event.delta.dx.abs() > event.delta.dy.abs()) {
                  return;
                }
                setState(() {
                  isDragging = true;
                  offset += event.delta;
                });
              }
            : (_) => setState(() {
                  isDragging = false;
                }),
        onPointerCancel: (_) {
          setState(() {
            prevOffset = offset;
            offset = Offset.zero;
          });
        },
        onPointerUp: isZoomedOut
            ? (_) {
                if (!isDragging) {
                  setState(() {
                    showButtons = !showButtons;
                  });
                  return;
                }

                setState(() {
                  isDragging = false;
                });

                final speed = (offset - prevOffset).distance;
                if (speed > speedThreshold || offset.dy.abs() > yThreshold) {
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    prevOffset = offset;
                    offset = Offset.zero;
                  });
                }
              }
            : (_) {
                setState(() {
                  prevOffset = offset;
                  offset = Offset.zero;
                  isDragging = false;
                });
              },
        child: AnimatedContainer(
          transform: Matrix4Transform()
              .scale(max(0.9, 1 - offset.dy.abs() / 1000))
              .translateOffset(offset)
              .rotate(min(-offset.dx / 2000, 0.1))
              .matrix4,
          duration:
              isDragging ? Duration.zero : const Duration(milliseconds: 200),
          child: PhotoView(
            backgroundDecoration:
                const BoxDecoration(color: Colors.transparent),
            scaleStateChangedCallback: (value) {
              setState(() {
                isZoomedOut = value == PhotoViewScaleState.zoomedOut ||
                    value == PhotoViewScaleState.initial;

                showButtons = isZoomedOut;

                scaleIsInitial = value == PhotoViewScaleState.initial;
                isDragging = false;
                prevOffset = offset;
                offset = Offset.zero;
              });
            },
            onTapUp: isZoomedOut
                ? (_, __, ___) => Navigator.of(context).pop()
                : (_, __, ___) => setState(() => showButtons = !showButtons),
            minScale: PhotoViewComputedScale.contained,
            initialScale: PhotoViewComputedScale.contained,
            imageProvider: CachedNetworkImageProvider(widget.url),
            heroAttributes: PhotoViewHeroAttributes(tag: widget.heroTag),
            loadingBuilder: (context, event) =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
        ),
      ),
    );
  }
}

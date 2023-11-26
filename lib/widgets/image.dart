import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:muffed/utils/image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

final _log = Logger('MuffedImageViewer');

/// Displays an image from a url
class MuffedImage extends StatefulWidget {
  ///
  const MuffedImage({
    required this.imageUrl,
    this.shouldBlur = false,
    this.animateSizeChange = true,
    this.numOfRetries = 3,
    this.fullScreenable = true,
    this.fit = BoxFit.contain,
    this.adjustableHeight = false,
    this.height,
    this.width,
    super.key,
  });

  /// The url of the image
  final String imageUrl;

  /// Whether the image should be initially blured
  final bool shouldBlur;

  /// The number of tries the widget will take to load the image
  final int numOfRetries;

  /// whether to animate the height of the widget changing when the image laods
  final bool animateSizeChange;

  /// Whether a tap on the image makes opens the image in full screen view
  final bool fullScreenable;

  /// Whether the height of the widget should be adjusted to the image
  final bool adjustableHeight;

  final double? height;
  final double? width;

  final BoxFit fit;

  @override
  State<MuffedImage> createState() => _MuffedImageState();
}

class _MuffedImageState extends State<MuffedImage> {
  double? height;
  late bool shouldBlur;
  late String heroTag;
  Size? imageSize;

  @override
  void initState() {
    height = widget.height;
    shouldBlur = widget.shouldBlur;
    heroTag = DateTime
        .now()
        .microsecondsSinceEpoch
        .toString()
        .substring(10);

    if (widget.adjustableHeight) {
      retrieveImageDimensions(widget.imageUrl).then((size) {
        if (mounted) {
          setState(() {
            imageSize = size;
          });
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final image = SizedBox(
      width: widget.width,
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (imageSize != null) {
            height =
                imageSize!.height / imageSize!.width * constraints.maxWidth;
          }

          return ExtendedImage.network(
            widget.imageUrl,
            fit: widget.fit,
            cache: true,
            loadStateChanged: (state) {
              if (state.extendedImageLoadState == LoadState.loading) {
                return Skeletonizer(
                  enabled: true,
                  child: Container(
                    height: height,
                    width: widget.width,
                  ),
                );
              }

              return null;
            },
            retries: widget.numOfRetries,
            handleLoadingProgress: true,
            alignment: Alignment.topCenter,
            clearMemoryCacheWhenDispose: false,
            enableMemoryCache: true,
          );
        },
      ),
    );

    return GestureDetector(
      onTap: (!shouldBlur && widget.fullScreenable)
          ? () {
        if (shouldBlur) {
          setState(() {
            shouldBlur = false;
          });
        } else if (widget.fullScreenable) {
          showFullScreenImageView(
            context,
            widget.imageUrl,
            heroTag,
          );
        }
      }
          : null,
      child: (widget.animateSizeChange)
          ? AnimatedSize(
        alignment: Alignment.topCenter,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        child: image,
      )
          : image,
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
  const FullScreenImageView({
    required this.url,
    required this.heroTag,
    super.key,
  });

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
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      body: Listener(
        onPointerMove: scaleIsInitial
            ? (event) {
          if (!isDragging &&
              event.delta.dx.abs() > event.delta.dy.abs()) {
            return;
          }
          setState(() {
            isDragging = true;
            offset += event.delta;
          });
        }
            : (_) =>
            setState(() {
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
            imageProvider: ExtendedNetworkImageProvider(widget.url),
            heroAttributes: PhotoViewHeroAttributes(tag: widget.heroTag),
            loadingBuilder: (context, event) =>
            const Center(child: CircularProgressIndicator.adaptive()),
          ),
        ),
      ),
    );
  }
}

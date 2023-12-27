import 'dart:async';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:muffed/utils/image.dart';

final _log = Logger('MuffedImageViewer');

/// Displays an image from a url
class MuffedImage extends StatefulWidget {
  ///
  const MuffedImage({
    required this.imageUrl,
    this.shouldBlur = false,
    this.animateSizeChange = false,
    this.numOfRetries = 3,
    this.fullScreenable = false,
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
    heroTag = DateTime.now().microsecondsSinceEpoch.toString().substring(10);
    if (widget.adjustableHeight) {
      cachedImageExists(widget.imageUrl).then((cachedImageExists) {
        if (!cachedImageExists) {
          retrieveImageDimensions(widget.imageUrl).then((size) {
            if (mounted) {
              setState(() {
                imageSize = size;
              });
            }
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final image = LayoutBuilder(
      builder: (context, constraints) {
        if (imageSize != null) {
          height = imageSize!.height / imageSize!.width * constraints.maxWidth;
        }
        return Hero(
          tag: heroTag,
          child: ExtendedImage.network(
            widget.imageUrl,
            width: widget.width,
            fit: widget.fit,
            loadStateChanged: (state) {
              if (state.extendedImageLoadState == LoadState.loading) {
                return SizedBox(
                  width: double.maxFinite,
                  height: height,
                );
              }
              return null;
            },
            retries: widget.numOfRetries,
            handleLoadingProgress: true,
          ),
        );
      },
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

// the below code was taken and modified from https://github.com/thunder-app/thunder/blob/b4be7d27c2f65ce261c6f2f96c2b351e18f01126/lib/shared/image_viewer.dart

void showFullScreenImageView(BuildContext context, String url, String heroTag) {
  Navigator.push(
    context,
    ImageViewerRoute(
      builder: (context) => FullScreenImageView(
        url: url,
        heroTag: heroTag,
      ),
    ),
  );
}

class ImageViewerRoute extends PageRoute<void>
    with MaterialRouteTransitionMixin<void> {
  ImageViewerRoute({
    required this.builder,
    super.settings,
    this.maintainState = true,
    super.fullscreenDialog,
  });

  final WidgetBuilder builder;

  @override
  Widget buildContent(BuildContext context) => builder(context);

  @override
  bool get opaque => false;

  @override
  final bool maintainState;

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}

class FullScreenImageView extends StatefulWidget {
  const FullScreenImageView({
    required this.heroTag,
    required this.url,
    this.postId,
    this.navigateToPost,
    super.key,
  });

  final String url;
  final int? postId;
  final void Function()? navigateToPost;
  final String heroTag;

  @override
  State<FullScreenImageView> createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView>
    with TickerProviderStateMixin {
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();
  final GlobalKey<ScaffoldMessengerState> _imageViewer =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<ExtendedImageGestureState> gestureKey =
      GlobalKey<ExtendedImageGestureState>();
  bool downloaded = false;

  double slideTransparency = 1;
  double imageTransparency = 1;

  bool maybeSlideZooming = false;
  bool slideZooming = false;
  bool fullscreen = false;
  Offset downCoord = Offset.zero;

  /// User Settings
  bool isUserLoggedIn = false;

  bool isDownloadingMedia = false;

  void _maybeSlide(BuildContext context) {
    setState(() {
      maybeSlideZooming = true;
    });
    Timer(const Duration(milliseconds: 300), () {
      if (context.mounted) {
        setState(() {
          maybeSlideZooming = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 140),
      vsync: this,
    );
    var animationListener = () {};
    Animation<double>? animation;

    return ScaffoldMessenger(
      key: _imageViewer,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: (fullscreen || slideTransparency < 0.95)
                ? Colors.transparent
                : Colors.white,
            shadows: fullscreen
                ? null
                : <Shadow>[const Shadow(blurRadius: 50)],
          ),
          backgroundColor: Colors.transparent,
          toolbarHeight: 70,
        ),
        backgroundColor: Colors.black.withOpacity(slideTransparency),
        body: Center(
          child: GestureDetector(
            onLongPress: () {
              setState(() {
                fullscreen = !fullscreen;
              });
            },
            // onTap: () {
            //   if (!fullscreen) {
            //     slidePagekey.currentState!.popPage();
            //     Navigator.pop(context);
            //   } else {
            //     setState(() {
            //       fullscreen = false;
            //     });
            //   }
            // },
            // Start doubletap zoom if conditions are met
            onVerticalDragStart: maybeSlideZooming
                ? (details) {
                    setState(() {
                      slideZooming = true;
                    });
                  }
                : null,
            // Zoom image in an out based on movement in vertical axis if conditions are met
            onVerticalDragUpdate: maybeSlideZooming || slideZooming
                ? (details) {
                    // Need to catch the drag during "maybe" phase or it wont activate fast enough
                    if (slideZooming) {
                      final double newScale = max(
                          gestureKey.currentState!.gestureDetails!.totalScale! *
                              (1 + (details.delta.dy / 150)),
                          1,);
                      gestureKey.currentState?.handleDoubleTap(
                        scale: newScale,
                        doubleTapPosition:
                            gestureKey.currentState!.pointerDownPosition,
                      );
                    }
                  }
                : null,
            // End doubltap zoom
            onVerticalDragEnd: slideZooming
                ? (details) {
                    setState(() {
                      slideZooming = false;
                    });
                  }
                : null,
            child: Listener(
              // Start watching for double tap zoom
              onPointerUp: (details) {
                downCoord = details.position;
                if (!slideZooming) {
                  _maybeSlide(context);
                }
              },
              child: ExtendedImageSlidePage(
                key: slidePagekey,
                slidePageBackgroundHandler: (offset, pageSize) {
                  return Colors.transparent;
                },
                onSlidingPage: (state) {
                  // Fade out image and background when sliding to dismiss
                  final offset = state.offset;
                  final pageSize = state.pageSize;

                  final scale = offset.distance /
                      Offset(pageSize.width, pageSize.height).distance;

                  if (state.isSliding) {
                    setState(() {
                      slideTransparency = 1 - min(1, scale * 4);
                      // imageTransparency = 1.0 - min(1.0, scale * 10);
                    });
                  }
                },
                slideEndHandler: (
                  // Decrease slide to dismiss threshold so it can be done easier
                  Offset offset, {
                  ExtendedImageSlidePageState? state,
                  ScaleEndDetails? details,
                }) {
                  if (state != null) {
                    final offset = state.offset;
                    final pageSize = state.pageSize;
                    return offset.distance.greaterThan(
                      Offset(pageSize.width, pageSize.height).distance / 10,
                    );
                  }
                  return true;
                },
                child: ExtendedImage.network(
                  widget.url,
                  color: Colors.white.withOpacity(
                    imageTransparency,
                  ),
                  colorBlendMode: BlendMode.dstIn,
                  enableSlideOutPage: true,
                  mode: ExtendedImageMode.gesture,
                  extendedImageGestureKey: gestureKey,
                  heroBuilderForSlidingPage: (child) => Hero(
                    tag: widget.heroTag,
                    child: child,
                  ),
                  initGestureConfigHandler: (ExtendedImageState state) {
                    return GestureConfig(
                      reverseMousePointerScrollDirection: true,
                      gestureDetailsIsChanged: (GestureDetails? details) {},
                    );
                  },
                  onDoubleTap: (ExtendedImageGestureState state) {
                    final pointerDownPosition = state.pointerDownPosition;
                    final begin = state.gestureDetails!.totalScale!;
                    double end;

                    animation?.removeListener(animationListener);
                    animationController
                      ..stop()
                      ..reset();

                    if (begin == 1) {
                      end = 2;
                    } else if (begin > 1.99 && begin < 2.01) {
                      end = 4;
                    } else {
                      end = 1;
                    }
                    animationListener = () {
                      state.handleDoubleTap(
                          scale: animation!.value,
                          doubleTapPosition: pointerDownPosition,);
                    };
                    animation = animationController
                        .drive(Tween<double>(begin: begin, end: end));

                    animation!.addListener(animationListener);

                    animationController.forward();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

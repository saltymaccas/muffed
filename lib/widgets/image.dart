import 'dart:async';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:muffed/theme/models/extentions.dart';
import 'package:shimmer/shimmer.dart';

final _log = Logger('MuffedImageViewer');

enum ImagePlaceHolderType {
  shimmer,
  shimmerAndLinearProgressIfAvailable,
  none,
}

/// Displays an image from a url
class MuffedImage extends StatefulWidget {
  const MuffedImage({
    required this.imageUrl,
    this.shouldBlur = false,
    this.animateSizeChange = false,
    this.numOfRetries = 3,
    this.fullScreenable = false,
    this.fit = BoxFit.contain,
    this.loadingPlaceholder = ImagePlaceHolderType.none,
    this.alignment = Alignment.center,
    this.height,
    this.width,
    this.sizeWhileLoading,
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

  /// The size the image should be while it is loading
  final Size? sizeWhileLoading;

  /// The widget to display while loading
  final ImagePlaceHolderType loadingPlaceholder;

  final Alignment alignment;

  final double? height;
  final double? width;

  final BoxFit fit;

  @override
  State<MuffedImage> createState() => _MuffedImageState();
}

class _MuffedImageState extends State<MuffedImage> {
  late bool shouldBlur;
  late String heroTag;

  @override
  void initState() {
    shouldBlur = widget.shouldBlur;
    heroTag = DateTime.now().microsecondsSinceEpoch.toString().substring(10);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      child: Hero(
        tag: heroTag,
        child: ExtendedImage.network(
          widget.imageUrl,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          retries: widget.numOfRetries,
          alignment: widget.alignment,
          loadStateChanged: (state) {
            if (state.wasSynchronouslyLoaded) {
              return state.completedWidget;
            }

            if (state.extendedImageLoadState == LoadState.completed ||
                state.extendedImageLoadState == LoadState.loading) {
              if (state.extendedImageLoadState == LoadState.completed) {
                return null;
              }
              return AnimatedCrossFade(
                sizeCurve: context.animationTheme.empasizedCurve,
                firstCurve: context.animationTheme.empasizedDecelerateCurve,
                reverseDuration: context.animationTheme.durLong,
                duration: context.animationTheme.durLong,
                alignment: widget.alignment,
                crossFadeState:
                    (state.extendedImageLoadState == LoadState.completed)
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                firstChild: ImageLoadingPlaceholder(
                  state: state,
                  placeholderType: widget.loadingPlaceholder,
                  size: widget.sizeWhileLoading,
                ),
                secondChild: state.completedWidget,
              );
            }

            return null;
          },
        ),
      ),
    );
  }
}

class ImageLoadingPlaceholder extends StatelessWidget {
  const ImageLoadingPlaceholder({
    required this.state,
    this.placeholderType = ImagePlaceHolderType.none,
    this.size,
    super.key,
  });

  final Size? size;

  final ImagePlaceHolderType placeholderType;

  final ExtendedImageState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: Builder(
        builder: (context) {
          switch (placeholderType) {
            case ImagePlaceHolderType.shimmer:
              return Shimmer.fromColors(
                period: const Duration(milliseconds: 2000),
                baseColor: context.colorScheme.outline.withOpacity(0.05),
                highlightColor: Colors.transparent,
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  color: Colors.red,
                ),
              );
            case ImagePlaceHolderType.shimmerAndLinearProgressIfAvailable:
              return Stack(
                children: [
                  Shimmer.fromColors(
                    period: const Duration(milliseconds: 2000),
                    baseColor: context.colorScheme.outline.withOpacity(0.05),
                    highlightColor: Colors.transparent,
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      color: Colors.red,
                    ),
                  ),
                  if (state.loadingProgress?.expectedTotalBytes != null)
                    Align(
                      alignment: Alignment.topCenter,
                      child: LinearProgressIndicator(
                        value: state.loadingProgress!.cumulativeBytesLoaded /
                            state.loadingProgress!.expectedTotalBytes!,
                      ),
                    ),
                ],
              );
            case ImagePlaceHolderType.none:
              return const SizedBox();
          }
        },
      ),
    );
  }
}

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
            shadows: fullscreen ? null : <Shadow>[const Shadow(blurRadius: 50)],
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
            onVerticalDragStart: maybeSlideZooming
                ? (details) {
                    setState(() {
                      slideZooming = true;
                    });
                  }
                : null,
            onVerticalDragUpdate: maybeSlideZooming || slideZooming
                ? (details) {
                    if (slideZooming) {
                      final double newScale = max(
                        gestureKey.currentState!.gestureDetails!.totalScale! *
                            (1 + (details.delta.dy / 150)),
                        1,
                      );
                      gestureKey.currentState?.handleDoubleTap(
                        scale: newScale,
                        doubleTapPosition:
                            gestureKey.currentState!.pointerDownPosition,
                      );
                    }
                  }
                : null,
            onVerticalDragEnd: slideZooming
                ? (details) {
                    setState(() {
                      slideZooming = false;
                    });
                  }
                : null,
            child: Listener(
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
                        doubleTapPosition: pointerDownPosition,
                      );
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

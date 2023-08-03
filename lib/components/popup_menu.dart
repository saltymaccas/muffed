import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
const double _kMenuHorizontalPadding = 16.0;
const double _kMenuDividerHeight = 16.0;
const double _kMenuMaxWidth = 5.0 * _kMenuWidthStep;
const double _kMenuMinWidth = 2.0 * _kMenuWidthStep;
const double _kMenuVerticalPadding = 8.0;
const double _kMenuWidthStep = 56.0;
const double _kMenuScreenPadding = 8.0;

/// Item to be put into [MuffedPopupMenuButton]
class MuffedPopupMenuItem extends StatelessWidget {
  ///
  const MuffedPopupMenuItem({
    super.key,
    this.title = 'Title',
    this.isSelected = false,
    this.onTap,

  });

  final bool isSelected;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (onTap == null) ? null : () {
        Navigator.pop(context);
        onTap!.call();
      },
      child: Container(
        color:
            isSelected ? Theme.of(context).colorScheme.outlineVariant : null,
        alignment: AlignmentDirectional.centerStart,
        constraints:
            const BoxConstraints(minHeight: kMinInteractiveDimension),
        padding:
            const EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

/// A widget the displays a button that when pressed pushes a menu
class MuffedPopupMenuButton extends StatefulWidget {
  ///
  const MuffedPopupMenuButton({
    required this.icon,
    required this.itemsBuilder,
    super.key,
    this.useRootNavigator = false,
    this.visualDensity = VisualDensity.comfortable,
    this.offset = Offset.zero,
  });

  final Widget icon;
  final List<MuffedPopupMenuItem> itemsBuilder;
  final bool useRootNavigator;
  final VisualDensity visualDensity;
  final Offset offset;

  @override
  State<MuffedPopupMenuButton> createState() => _MuffedPopupMenuButtonState();
}

class _MuffedPopupMenuButtonState extends State<MuffedPopupMenuButton> {
  bool menuOpen = false;

  @override
  Widget build(BuildContext context) {
    void showMuffedMenu() {
      setState(() {
        menuOpen = true;
      });

      final RenderBox button = context.findRenderObject()! as RenderBox;
      final RenderBox overlay = Navigator.of(context)
          .overlay!
          .context
          .findRenderObject()! as RenderBox;

      // Gets position of button
      final RelativeRect position = RelativeRect.fromRect(
        Rect.fromPoints(
          button.localToGlobal(widget.offset, ancestor: overlay),
          button.localToGlobal(
            button.size.bottomRight(Offset.zero) + widget.offset,
            ancestor: overlay,
          ),
        ),
        Offset.zero & overlay.size,
      );

      Navigator.of(context, rootNavigator: widget.useRootNavigator)
          .push(
        _MuffedPopupMenuRoute(
          position: position,
          barrierLabel: 'test',
          items: widget.itemsBuilder,
        ),
      )
          .then((value) {
        // added delay to set menu open to false when the animation has
        // finished
        Future.delayed(
          _kMenuDuration,
          () {
            setState(() {
              menuOpen = false;
            });
          },
        );
      });
    }

    return IconButton(
      onPressed: showMuffedMenu,
      isSelected: menuOpen,
      icon: widget.icon,
      visualDensity: widget.visualDensity,
    );
  }
}

/// The route that gets pushed to display the menu
class _MuffedPopupMenuRoute extends PopupRoute<dynamic> {
  _MuffedPopupMenuRoute({
    required this.position,
    required this.items,
    // padded on bottom to avoid navigation bar
    this.padding = const EdgeInsets.only(bottom: 40),
    this.barrierLabel = '',
  });

  /// The position the the button that displays the menu when presses, used to
  /// determine the menu position
  final RelativeRect position;

  final List<MuffedPopupMenuItem> items;

  final EdgeInsets padding;

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd),
    );
  }

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Builder(
      builder: (context) {
        final menu = _MuffedPopupMenu(route: this);
        final MediaQueryData mediaQuery = MediaQuery.of(context);

        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          removeLeft: true,
          removeRight: true,
          child: Builder(
            builder: (context) {
              return CustomSingleChildLayout(
                delegate: _MuffedMenuRouteLayout(
                  position,
                  padding,
                  _avoidBounds(
                    mediaQuery,
                  ),
                ),
                child: menu,
              );
            },
          ),
        );
      },
    );
  }

  Set<Rect> _avoidBounds(MediaQueryData mediaQuery) {
    return DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();
  }
}

/// The actual menu widget
class _MuffedPopupMenu extends StatelessWidget {
  _MuffedPopupMenu({
    super.key,
    required this.route,
  });

  final _MuffedPopupMenuRoute route;

  @override
  Widget build(BuildContext context) {
    final double unit = 1.0 / (route.items.length + 1.5);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);

    final child = ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: _kMenuMinWidth,
        maxWidth: _kMenuMaxWidth,
      ),
      child: IntrinsicWidth(
        stepWidth: _kMenuWidthStep,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: _kMenuVerticalPadding,
          ),
          child: ListBody(children: route.items),
        ),
      ),
    );

    final CurveTween opacity =
        CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
    final CurveTween width = CurveTween(curve: Interval(0.0, unit));
    final CurveTween height =
        CurveTween(curve: Interval(0.0, unit * route.items.length));

    return AnimatedBuilder(
      animation: route.animation!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: opacity.animate(route.animation!),
          child: Material(
            clipBehavior: Clip.hardEdge,
            type: MaterialType.card,
            shape: popupMenuTheme.shape,
            color: popupMenuTheme.color,
            elevation: popupMenuTheme.elevation ?? 5,
            surfaceTintColor: popupMenuTheme.surfaceTintColor,
            shadowColor: popupMenuTheme.color,
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              widthFactor: width.evaluate(route.animation!),
              heightFactor: height.evaluate(route.animation!),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

// Positions the menu
class _MuffedMenuRouteLayout extends SingleChildLayoutDelegate {
  _MuffedMenuRouteLayout(
    this.position,
    this.padding,
    this.avoidBounds,
  );

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // The padding of unsafe area.
  EdgeInsets padding;

  // List of rectangles that we should avoid overlapping. Unusable screen area.
  final Set<Rect> avoidBounds;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(_kMenuScreenPadding) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    final double buttonHeight = size.height - position.top - position.bottom;
    // Find the ideal vertical position.
    double y = position.top;

    // Find the ideal horizontal position.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    } else {
      // Menu button is equidistant from both edges, so grow in reading direction.
      x = size.width - position.right - childSize.width;
    }

    final Offset wantedPosition = Offset(x, y);
    final Offset originCenter = position.toRect(Offset.zero & size).center;
    final Iterable<Rect> subScreens =
        DisplayFeatureSubScreen.subScreensInBounds(
            Offset.zero & size, avoidBounds);
    final Rect subScreen = _closestScreen(subScreens, originCenter);
    return _fitInsideScreen(subScreen, childSize, wantedPosition);
  }

  Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    Rect closest = screens.first;
    for (final Rect screen in screens) {
      if ((screen.center - point).distance <
          (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }

  Offset _fitInsideScreen(Rect screen, Size childSize, Offset wantedPosition) {
    double x = wantedPosition.dx;
    double y = wantedPosition.dy;
    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    if (x < screen.left + _kMenuScreenPadding + padding.left) {
      x = screen.left + _kMenuScreenPadding + padding.left;
    } else if (x + childSize.width >
        screen.right - _kMenuScreenPadding - padding.right) {
      x = screen.right - childSize.width - _kMenuScreenPadding - padding.right;
    }
    if (y < screen.top + _kMenuScreenPadding + padding.top) {
      y = _kMenuScreenPadding + padding.top;
    } else if (y + childSize.height >
        screen.bottom - _kMenuScreenPadding - padding.bottom) {
      y = screen.bottom -
          childSize.height -
          _kMenuScreenPadding -
          padding.bottom;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_MuffedMenuRouteLayout oldDelegate) {
    return position != oldDelegate.position || padding != oldDelegate.padding;
  }
}

import 'package:flutter/material.dart';

class LoadingComponentTransparent extends StatelessWidget {
  const LoadingComponentTransparent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class LoadingComponentTransparentLogo extends StatelessWidget {
  const LoadingComponentTransparentLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.onPrimaryContainer,
                Theme.of(context).colorScheme.onTertiaryContainer
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
}

///
class MuffedPageLoadingIndicator extends StatelessWidget {
  /// Meant to be wrapped around a page to provide a linear progress indicator
  /// at the top
  const MuffedPageLoadingIndicator({
    required this.child,
    required this.isLoading,
    super.key,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          const SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

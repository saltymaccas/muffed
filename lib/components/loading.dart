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

import 'package:flutter/material.dart';

class LoadingComponentTransparent extends StatelessWidget {
  const LoadingComponentTransparent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(),);
  }
}

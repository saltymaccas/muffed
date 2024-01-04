import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/local_store/local_store.dart';
import 'package:muffed/widgets/image.dart';
import 'package:muffed/widgets/link_previewer.dart';

/// displays the content of any url
class UrlView extends StatelessWidget {
  const UrlView({
    required this.url,
    this.nsfw = false,
    this.imageFullScreenable = true,
    super.key,
  });

  final String url;
  final bool nsfw;
  final bool imageFullScreenable;

  @override
  Widget build(BuildContext context) {
    final urlPath = Uri.parse(url).path;

    if (urlPath.endsWith('.jpg') ||
        urlPath.endsWith('.png') ||
        urlPath.endsWith('.jpeg') ||
        urlPath.endsWith('.gif') ||
        urlPath.endsWith('.webp') ||
        urlPath.endsWith('.bmp')) {
      return MuffedImage(
        imageUrl: url,
        shouldBlur: nsfw && context.read<LocalStore>().state.blurNsfw,
        fullScreenable: imageFullScreenable,
        sizeWhileLoading: const Size(double.maxFinite, 300),
        alignment: Alignment.topCenter,
        loadingPlaceholder:
            ImagePlaceHolderType.shimmerAndLinearProgressIfAvailable,
        width: double.maxFinite,
        animateSizeChange: true,
        fit: BoxFit.fitWidth,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: LinkPreviewer(link: url),
      );
    }
  }
}

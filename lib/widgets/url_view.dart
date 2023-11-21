import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/widgets/image.dart';
import 'package:muffed/widgets/link_previewer.dart';
import 'package:url_launcher/url_launcher.dart';

/// displays the content of any url
class UrlView extends StatelessWidget {
  const UrlView({
    required this.url,
    this.nsfw = false,
    this.tapImageAnywhereForFullScreen = true,
    super.key,
  });

  final String url;
  final bool nsfw;
  final bool tapImageAnywhereForFullScreen;

  @override
  Widget build(BuildContext context) {
    final urlPath = Uri.parse(url).path;

    if (urlPath.endsWith('.jpg') ||
        urlPath.endsWith('.png') ||
        urlPath.endsWith('.jpeg') ||
        urlPath.endsWith('.gif') ||
        urlPath.endsWith('.webp') ||
        urlPath.endsWith('.bmp')) {
      return SizedBox(
        child: Center(
          child: MuffedImage(
            imageUrl: url,
            shouldBlur: nsfw && context.read<GlobalBloc>().state.blurNsfw,
            tapAnywhereForFullScreen: tapImageAnywhereForFullScreen,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          height: 100,
          child: (true)
              ? LinkPreviewer(url: url)
              : AnyLinkPreview(
                  cache: const Duration(days: 1),
                  placeholderWidget: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    color: Theme.of(context).colorScheme.surface,
                    child: const Center(
                      child: Text('Loading url data'),
                    ),
                  ),
                  errorImage: 'null',
                  errorBody: 'Could not load body',
                  errorWidget: GestureDetector(
                    onTap: () => launchUrl(Uri.parse(url)),
                    child: Container(
                      color: Theme.of(context).colorScheme.background,
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        url,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  bodyTextOverflow: TextOverflow.fade,
                  removeElevation: true,
                  borderRadius: 10,
                  boxShadow: const [],
                  link: url,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  displayDirection: UIDirection.uiDirectionHorizontal,
                  titleStyle: Theme.of(context).textTheme.titleSmall,
                ),
        ),
      );
    }
  }
}

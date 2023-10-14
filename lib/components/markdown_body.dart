import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:muffed/components/image.dart';
import 'package:muffed/components/snackbars.dart';
import 'package:url_launcher/url_launcher.dart';

class MuffedMarkdownBody extends StatelessWidget {
  const MuffedMarkdownBody({
    super.key,
    required this.data,
    this.height,
    this.onTapText,
    this.padding = const EdgeInsets.all(4),
    this.physics = const NeverScrollableScrollPhysics(),
  });

  final String data;
  final ScrollPhysics physics;
  final double? height;
  final EdgeInsets padding;
  final void Function()? onTapText;

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: height ?? double.infinity,
      child: Markdown(
        imageBuilder: (uri, title, alt) {
          return MuffedImage(
            imageUrl: uri.toString(),
            initialHeight: 0,
            animateSizeChange: false,
          );
        },
        onTapLink: (
          title,
          link,
          destination,
        ) async {
          if (link != null) {
            if (!await launchUrl(Uri.parse(link))) {
              showErrorSnackBar(context, error: 'Failed to open link');
            }
          }
        },
        onTapText: onTapText,
        data: data,
        shrinkWrap: true,
        selectable: true,
        physics: physics,
        padding: padding,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          blockquoteDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              left: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: 4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

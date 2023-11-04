import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:muffed/components/image.dart';

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
          url,
          destination,
        ) async {
          if (url != null) {
            // CHECK IF EMAIL STYLE LINK TO USER
            // Format: @user@lemmy.world
            if (url.startsWith('@')) {
              // remove the '@'
              final username = url.substring(1);

              await context.push(
                Uri(
                  path: '/home/person/',
                  queryParameters: {'username': username},
                ).toString(),
              );
              return;
            }
          }
        },
        onTapText: onTapText,
        data: data,
        shrinkWrap: true,
        selectable: true,
        physics: physics,
        padding: padding,
        inlineSyntaxes: [LemmyLinkSyntax()],
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

// taken from: https://github.com/liftoff-app/liftoff/blob/3055896657ef05772dc5fa18c5b3ab285b93f54a/lib/widgets/markdown_text.dart#L18
class LemmyLinkSyntax extends md.InlineSyntax {
  // https://github.com/LemmyNet/lemmy-ui/blob/61255bf01a8d2acdbb77229838002bf8067ada70/src/shared/config.ts#L38
  static const String _pattern =
      r'(\/[cmu]\/|@|!)([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})';

  LemmyLinkSyntax() : super(_pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final modifier = match[1]!;
    final name = match[2]!;
    final url = match[3]!;
    final anchor = md.Element.text('a', '$modifier$name@$url');

    anchor.attributes['href'] = '$modifier$name@$url';
    parser.addNode(anchor);

    return true;
  }
}

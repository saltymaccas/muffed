import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:muffed/widgets/image.dart';
import 'package:url_launcher/url_launcher.dart';

class MuffedMarkdownBody extends StatelessWidget {
  const MuffedMarkdownBody({
    required this.data,
    super.key,
    this.controller,
    this.physics = const NeverScrollableScrollPhysics(),
    this.shrinkWrap = true,
    this.onTapText,
    this.maxHeight,
  });
  final String data;

  final double? maxHeight;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final ScrollController? controller;
  final void Function()? onTapText;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? double.infinity,
      ),
      child: MarkdownBody(
        listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,
        shrinkWrap: true,
        // extensionSet: md.ExtensionSet.gitHubWeb,
        data: data,
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
            // check if link to community
            if (url.startsWith('!')) {
              await context.push(
                Uri(
                  path: '/home/community/',
                  queryParameters: {'name': url.substring(1)},
                ).toString(),
              );
              return;
            }

            // check if link to user
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

            final path = Uri.parse(url).path;
            final spiltPath = path.split('/');
            final host = Uri.parse(url).host;

            print(host);

            final chonks = url.split('/');

            if (chonks.length == 1) {
              await launchUrl(Uri.parse(url));
              return;
            }

            // check if link to user
            if (path.startsWith('/u/')) {
              await context.pushNamed(
                'person',
                queryParameters: {
                  'username': '${spiltPath[2]}@$host',
                },
              );
              return;
            }

            // check if link to community
            if (path.startsWith('/c/')) {
              await context.pushNamed(
                'community',
                queryParameters: {
                  'name': '${spiltPath[2]}@$host',
                },
              );
              return;
            }

            await launchUrl(Uri.parse(url));
          }
        },
        onTapText: onTapText,
        selectable: false,
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
  LemmyLinkSyntax() : super(_pattern);
  // https://github.com/LemmyNet/lemmy-ui/blob/61255bf01a8d2acdbb77229838002bf8067ada70/src/shared/config.ts#L38
  static const String _pattern =
      r'(\/[cmu]\/|@|!)([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})';

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
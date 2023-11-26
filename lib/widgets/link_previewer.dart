import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:muffed/shorthands.dart';
import 'package:muffed/utils/url.dart';
import 'package:muffed/widgets/error.dart';
import 'package:muffed/widgets/image.dart';
import 'package:url_launcher/url_launcher.dart';

enum _LinkPreviewerStatus { initial, loading, success, error }

class LinkPreviewer extends StatefulWidget {
  LinkPreviewer({
    required String link,
    this.height = 100,
    this.width = double.maxFinite,
    this.imageWidth = 120,
    this.titleTextStyle,
    this.bodyTextStyle,
    this.cache = const Duration(days: 1),
    this.headers,
    super.key,
  }) : link = cleanseUrl(link);

  final String link;
  final double height;
  final double width;
  final double imageWidth;
  final TextStyle? titleTextStyle;
  final TextStyle? bodyTextStyle;
  final Duration cache;
  final Map<String, String>? headers;

  @override
  State<LinkPreviewer> createState() => _LinkPreviewerState();
}

class _LinkPreviewerState extends State<LinkPreviewer> {
  _LinkPreviewerStatus status = _LinkPreviewerStatus.initial;
  Object? error;
  Metadata? metadata;

  @override
  void initState() {
    final linkValid = AnyLinkPreview.isValidLink(widget.link);

    if (linkValid) {
      status = _LinkPreviewerStatus.loading;
      AnyLinkPreview.getMetadata(
        link: widget.link,
        cache: widget.cache,
        headers: widget.headers,
      )
          .then(
            (value) => {
              if (mounted)
                {
                  setState(() {
                    status = _LinkPreviewerStatus.success;
                    metadata = value;
                  }),
                },
            },
          )
          .catchError(
            (Object error) => {
              if (mounted)
                {
                  setState(() {
                    status = _LinkPreviewerStatus.error;
                    this.error = error;
                  }),
                },
            },
          );
    } else {
      status = _LinkPreviewerStatus.error;
      error = 'Invalid link';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(widget.link)),
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Theme.of(context).colorScheme.surface,
        ),
        clipBehavior: Clip.hardEdge,
        child: Builder(
          builder: (context) {
            switch (status) {
              case _LinkPreviewerStatus.initial:
                return const SizedBox();
              case _LinkPreviewerStatus.loading:
                return const Text('Loading url data...');
              case _LinkPreviewerStatus.error:
                return ErrorComponentTransparent(
                  error: error,
                  showErrorIcon: false,
                );
              case _LinkPreviewerStatus.success:
                if (metadata == null) {
                  return Text(widget.link);
                }
                return Row(
                  children: [
                    SizedBox(
                      width: widget.imageWidth,
                      height: widget.height,
                      child: MuffedImage(
                        fullScreenable: false,
                        imageUrl: metadata!.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Set text styles
                          final titleTextStyle = widget.titleTextStyle ??
                              context.textTheme().titleMedium!;

                          final bodyTextStyle = widget.bodyTextStyle ??
                              context.textTheme().bodySmall!;

                          final bool titleAvailable = metadata!.title != null &&
                              metadata!.title!.isNotEmpty;

                          final bool bodyAvailable = metadata!.desc != null &&
                              metadata!.desc!.isNotEmpty;

                          // get height and max lines of title
                          int? maxTitleLines;
                          double? titleHeight;

                          if (titleAvailable) {
                            final titleTextPainter = TextPainter()
                              ..text = TextSpan(
                                text: metadata!.title,
                                style: titleTextStyle,
                              )
                              ..textDirection = TextDirection.ltr
                              ..layout(maxWidth: constraints.maxWidth);

                            final titleLineHeight =
                                titleTextPainter.computeLineMetrics().isNotEmpty
                                    ? titleTextPainter
                                        .computeLineMetrics()[0]
                                        .height
                                    : 0;

                            final heightForTitle = bodyAvailable
                                ? widget.height / 2
                                : widget.height;

                            maxTitleLines =
                                (heightForTitle / titleLineHeight).floor();

                            titleHeight =
                                titleLineHeight * maxTitleLines.toDouble();
                          }

                          // get max lines of body
                          int? maxBodyLines;

                          if (bodyAvailable) {
                            final bodyTextPainter = TextPainter()
                              ..text = TextSpan(
                                text: metadata!.desc,
                                style: bodyTextStyle,
                              )
                              ..textDirection = TextDirection.ltr
                              ..layout(maxWidth: constraints.maxWidth);

                            final bodyTextLineHeight =
                                bodyTextPainter.computeLineMetrics()[0].height;

                            final bodyTextAvailableHeight =
                                widget.height - (titleHeight ?? 0);

                            maxBodyLines =
                                (bodyTextAvailableHeight / bodyTextLineHeight)
                                    .floor();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (titleAvailable)
                                Text(
                                  metadata!.title!,
                                  style: titleTextStyle,
                                  maxLines: maxTitleLines,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (bodyAvailable)
                                Text(
                                  metadata!.desc!,
                                  style: bodyTextStyle,
                                  maxLines: maxBodyLines,
                                  overflow: TextOverflow.fade,
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MuffedMarkdownBody extends StatelessWidget {
  const MuffedMarkdownBody({
    super.key,
    required this.data,
    this.height,
    this.padding = const EdgeInsets.all(4),
    this.physics = const NeverScrollableScrollPhysics(),
  });

  final String data;
  final ScrollPhysics physics;
  final double? height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: height ?? double.infinity,
      child: Markdown(
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
                    color: Theme.of(context).colorScheme.outline, width: 4)),
          ),
        ),
      ),
    );
  }
}

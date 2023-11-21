import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:muffed/widgets/image.dart';

class LinkPreviewer extends StatefulWidget {
  const LinkPreviewer({
    required this.url,
    super.key,
  });

  final String url;

  @override
  State<LinkPreviewer> createState() => _LinkPreviewerState();
}

class _LinkPreviewerState extends State<LinkPreviewer> {
  Metadata? metadata;

  @override
  void initState() {
    super.initState();
    AnyLinkPreview.getMetadata(link: widget.url).then(
      (value) {
        setState(() {
          metadata = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (metadata == null) {
      AnyLinkPreview.getMetadata(link: widget.url).then(
        (value) {
          setState(() {
            metadata = value;
          });
        },
      );
    }
    return Container(
      height: 100,
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).colorScheme.surface,
      ),
      clipBehavior: Clip.hardEdge,
      child: (metadata == null)
          ? const Center(
              child: Text('Loading url data...'),
            )
          : Row(
              children: [
                SizedBox(
                  width: 120,
                  height: 100,
                  child: MuffedImage(
                    imageUrl: metadata!.image!,
                    fit: BoxFit.cover,
                    getImageSize: false,
                  ),
                ),
              ],
            ),
    );
  }
}

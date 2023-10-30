import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muffed/components/snackbars.dart';
import 'package:muffed/repo/pictrs/models.dart';

import 'icon_button.dart';

/// A widget that displays uploaded images and their upload progress.
class ImageUploadView extends StatelessWidget {
  /// Creates a widget that displays uploaded images and their upload progress.
  const ImageUploadView({
    required this.images,
    required this.onDelete,
    super.key,
  });

  final SplayTreeMap<int, ImageUploadState> images;
  final void Function(int) onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'Images:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ...List.generate(images.length, (index) {
          final item = images[images.keys.toList()[index]]!;
          return Padding(
            padding: EdgeInsets.only(left: 4),
            child: Row(
              children: [
                Text(
                  item.id.toString(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                if (item.imageLink == null)
                  IconButtonLoading()
                else
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(
                          text: '![](${item.imageLink!})',
                        ),
                      );
                      if (!context.mounted) return;
                      showInfoSnackBar(
                        context,
                        text: 'Copied image URL to clipboard',
                      );
                    },
                  ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: item.uploadProgress,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: (item.deleteToken == null)
                      ? null
                      : () {
                          showDialog<void>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Delete image?'),
                                content: Text(
                                    'Are you sure you want to delete this image?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                      );
                                      onDelete(item.id!);
                                    },
                                    child: Text('Yes'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                    child: Text('No'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                ),
              ],
            ),
          );
        }),
        Divider(),
      ],
    );
  }
}

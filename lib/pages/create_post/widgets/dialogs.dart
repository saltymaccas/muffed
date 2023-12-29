import 'package:flutter/material.dart';
import 'package:muffed/router/models/extensions.dart';

void showAddDialog({
  required BuildContext context,
  required TextEditingController urlTextController,
  required void Function() addEnteredURlCallback,
  required Future<void> Function() openImagePickerForImageUpload,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                context.pop();
                showAddUrlDialog(
                  context: context,
                  urlTextController: urlTextController,
                  addEnteredURl: addEnteredURlCallback,
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(500, 50),
              ),
              child: const Text('Add Url'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () async {
                context.pop();
                await openImagePickerForImageUpload();
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(500, 50),
              ),
              child: const Text('Add Image'),
            ),
          ),
        ],
      ),
    ),
  );
}

void showAddUrlDialog({
  required BuildContext context,
  required TextEditingController urlTextController,
  required void Function() addEnteredURl,
}) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: urlTextController,
                decoration: InputDecoration(
                  hintText: 'Url',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: urlTextController.clear,
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                ),
                keyboardType: TextInputType.url,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  if (urlTextController.text.isNotEmpty) {
                    addEnteredURl();
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(500, 50),
                ),
                child: const Text('Add Url'),
              ),
            ),
          ],
        ),
      );
    },
  );
}

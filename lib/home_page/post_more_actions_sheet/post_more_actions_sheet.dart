import 'package:flutter/material.dart';
import 'package:muffed/repo/server_repo.dart';

void showPostMoreActionsSheet(BuildContext context, LemmyPost post) {
  showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.perm_device_info),
            title: Text('Show debug info'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Debug Info'),
                      content: SelectableText(
                          "id: ${post.id}\nname: ${post.name}\nbody: ${post.body}\nurl: ${post.url}\nthumb url: ${post.thumbnailUrl}"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('close'),
                        )
                      ],
                    );
                  });
            },
          )
        ],
      );
    },
  );
}

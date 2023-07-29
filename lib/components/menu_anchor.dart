import 'package:flutter/material.dart';

class MuffedMenuAnchor extends StatelessWidget {
  const MuffedMenuAnchor(
      {required this.icon, required this.menuChildren, required this.onClose, required this.onOpen, super.key,});

  final List<Widget> menuChildren;
  final void Function() onOpen;
  final void Function() onClose;

  final IconData icon;

  @override
  Widget build(BuildContext context) {

    return MenuAnchor(
      childFocusNode: FocusNode(),
      onOpen: onOpen,
      onClose: onClose,
      menuChildren: menuChildren,
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () {
            if (!controller.isOpen) {
              controller.open();
            } else {
              controller.close();
            }
          },
          icon: Icon(icon),
          visualDensity: VisualDensity.compact,
        );
      },
    );
  }
}

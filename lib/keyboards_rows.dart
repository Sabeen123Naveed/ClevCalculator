import 'package:flutter/material.dart';

import 'keyboards_buttons.dart';


class KeyboardRows extends StatelessWidget {
  KeyboardRows({required this.rowsButtons,  this.onTap});

  final List<String> rowsButtons;
  final CallbackButtonTap? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: buttons(),
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }

  List<Widget> buttons() {
    List<Widget> buttons = [];
    rowsButtons.forEach((String buttonText) {
      buttons.add(
        KeyboardButtons(
          buttons: buttonText,
          onTap: onTap,
        ),
      );
    });
    return buttons;
  }
}

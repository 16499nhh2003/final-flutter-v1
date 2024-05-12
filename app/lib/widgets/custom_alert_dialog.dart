import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback? onOkPressed;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    this.onOkPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onOkPressed != null) {
              onOkPressed!();
            }
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

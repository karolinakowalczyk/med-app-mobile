import 'package:flutter/material.dart';

class AlertWindow extends StatelessWidget {
  final String title;
  final String message;

  const AlertWindow({
    required this.title,
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

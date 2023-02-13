import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final RemoteMessage message;

  const InfoDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget detail = Text("unknown");
    switch (message.from) {
      case "/topics/cam-event":
        detail = Image.network(message.data["imagePath"]);
        break;
      case "/topics/cam-status":
        detail = Text("Armed: ${message.data["armed"]}");
        break;
    }

    return AlertDialog(
      title: Text(message.notification!.title!),
      scrollable: true,
      content: Column(children: [
        Text(message.notification!.body!),
        detail,
      ]),
      actions: [
        TextButton(
          child: Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// callback, will be called when app is in background or terminated state
Future<void> _messageHandler(RemoteMessage message) async {
  print('background message: ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MessagingTutorial());
}

class MessagingTutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PushCam',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'Puškam'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;
  String? notificationText;
  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("cam-event");
    messaging.getToken().then((value) {
      print('messaging token: $value');
    });

    // message received when the application in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      print(event.data);

/*   "notification": {
    "title": "Cam Notification",
    "body": "From Postman"
  },
  "data": {
      "msg": "Manual Alert",
      "imagePath": "pushcam-c9768.appspot.com/1676041073252.png",
      "name": "Sklep 1",
      "camId": "1",
      "location": "Sklep",
      "runTime": 55915,
      "timestampUt": "Fri, 10 Feb 2023 14:57:53 GMT",
      "group": "Sklepy",
      "objectType": "2"
  } */


      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(event.notification!.title!),
              content: Wrap(
                children:[
                Text(event.notification!.body!),
                Image.network(event.data["imagePath"]),
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
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(child: Text("Messaging Tutorial")),
    );
  }
}

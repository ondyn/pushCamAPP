import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:push_cam_app/InfoDialog.dart';
import 'firebase_options.dart';

// callback, will be called when app is in background or terminated state
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('background message: ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print('Message clicked!');
    showDialog(
        context: context, builder: (context) => InfoDialog(message: message));
  }

  Future<void> doArming(bool state, int cameraId) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("commands/cameras/$cameraId/arm");
    String time = DateTime.now().millisecondsSinceEpoch.toString();

    //await ref.set({"armedCmd": state, "lastTimeStampUtc": time});
    await ref.update({"armedCmd": state, "lastTimeStampUtc": time});
  }

  Future<void> requestImage(int cameraId) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("commands/cameras/$cameraId/image");
    String time = DateTime.now().millisecondsSinceEpoch.toString();

    //await ref.set({"armedCmd": state, "lastTimeStampUtc": time});
    await ref.update({"lastTimeStampUtc": time});
  }

  bool armStatus = true;

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("cam-event");
    messaging.subscribeToTopic("cam-status");
    messaging.getToken().then((value) {
      print('messaging token: $value');
    });

    // message received when the application in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("message recieved");
      print(message.notification!.body);
      print(message.data);

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
          context: context, builder: (context) => InfoDialog(message: message));
    });
    setupInteractedMessage();

    DatabaseReference camStatusRef =
        FirebaseDatabase.instance.ref('statuses/cameras/1/arm');
    camStatusRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map;
      setState(() {
        armStatus = data["armed"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(children: [
            Text(armStatus ? 'Armed' : 'NOT armed',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: armStatus ? Colors.redAccent : Colors.greenAccent,
                    height: 5,
                    fontSize: 30)),
            SizedBox(
              width: 200,
              height: 100,
              child: ElevatedButton(
                onPressed: () async {
                  doArming(true, 1);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                ),
                child: Text("Arm room",
                    style:
                        TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 100,
              child: ElevatedButton(
                onPressed: () async {
                  doArming(false, 1);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.greenAccent)),
                child: Text("Disarm room",
                    style:
                        TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 100,
              child: ElevatedButton(
                onPressed: () async {
                  requestImage(1);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.greenAccent),
                ),
                child: Text("Request image",
                    style:
                        TextStyle(fontSize: 20)),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

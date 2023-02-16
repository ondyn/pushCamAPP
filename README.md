# pushCamAPP

Flutter app

- install flutter


https://petercoding.com/firebase/2021/05/04/using-firebase-cloud-messaging-in-flutter/

put google-services.json into /android/app/

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Postman

curl --location --request POST 'https://fcm.googleapis.com/fcm/send' \
--header 'Authorization: Bearer AAA-Q:APAHOuq....IHj94Umgd' \
--header 'Content-Type: application/json' \
--data-raw '{
  "to": "/topics/messaging",
  "notification": {
    "title": "FCM",
    "body": "messaging tutorial"
  },
  "data": {
    "msgId": "msg_12342"
  }
}'

## generate icons
flutter pub run flutter_launcher_icons

## commands
flutter run
flutter clean
flutter build apk
flutter install

## init
npm install -g firebase-tools
firebase login

## hints
https://github.com/sbis04/flutter-authentication/tree/master/lib
https://www.kodeco.com/24346128-firebase-realtime-database-tutorial-for-flutter

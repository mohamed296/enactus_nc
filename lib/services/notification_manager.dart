import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationManager {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  void registerNotification(String email) {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        // ignore: avoid_print
        print('onMessage: $message');
        // ignore: avoid_print
        Platform.isAndroid
            // ignore: avoid_print
            ? print(message['notification'])
            // ignore: avoid_print
            : print(message['aps']['alert']);
        return;
      },
      onResume: (Map<String, dynamic> message) {
        // ignore: avoid_print
        print('onResume: $message');
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        // ignore: avoid_print
        print('onLaunch: $message');
        return;
      },
    );
  }

  Future getAndSaveToken(String id) async {
    firebaseMessaging.getToken().then((token) {
      // ignore: avoid_print
      print('token: $token');
      FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .update({'Token': token});
    }).catchError((err) {
      // ignore: avoid_print
      print(err.message.toString());
    });
  }
}

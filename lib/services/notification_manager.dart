import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationManager {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  void registerNotification(String email) {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid ? print(message['notification']) : print(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance.collection('users').doc(email).update({'pushToken': token});
    }).catchError((err) {
      print(err.message.toString());
    });
  }

  getAndSaveToken(String id) async {
    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance.collection('Users').doc(id).update({'Token': token});
    }).catchError((err) {
      print(err.message.toString());
    });
  }
}

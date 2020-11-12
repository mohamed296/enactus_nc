import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:enactusnca/Models/notification_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationServices {
  final user = FirebaseAuth.instance.currentUser;

  String notificationMsg(NotificationModel notificationModel, bool like) {
    String notificationMsg;
    if (notificationModel.notificationEvent == null) {
      if (like) {
        notificationMsg =
            '${user.displayName} Likes your post ${notificationModel.notificationPost.description.substring(3)}';
      } else {
        notificationMsg =
            '${user.displayName} Comment in your post ${notificationModel.notificationPost.description.substring(3)}';
      }
    } else {
      notificationMsg = '${user.displayName} Add a new Event';
    }

    return notificationMsg;
  }

  Future sendNotification(NotificationModel notificationModel, bool like) async {
    String notificationMessage = notificationMsg(notificationModel, like);
    String notificationTime = formatDate(
      DateTime.now(),
      [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn],
    );
    final path = FirebaseFirestore.instance
        .collection('Users')
        .doc(notificationModel.receiverId)
        .collection('Notification')
        .doc();

    var addNotification = await path.set({
      'senderId': user.uid,
      'receiverId': notificationModel.receiverId,
      'senderName': user.displayName,
      'senderImg': user.photoURL,
      'notificationMsg': notificationMessage,
      'notificationTime': notificationTime,
      // 'notificationPost': notificationModel.notificationPost,
      'notificationEvent': notificationModel.notificationEvent,
    });
    return addNotification;
  }

  removeNotification({@required String notificationId}) async {
    final path = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Notification')
        .doc(notificationId);

    final item = await path.get();

    if (item.exists)
      return await item.reference.delete();
    else
      return null;
  }

  List<NotificationModel> listOfNotification(QuerySnapshot snapshot) {
    var listOfNotification = snapshot.docs
        .map(
          (notifi) => NotificationModel(
            notificationId: notifi.id,
            receiverId: notifi.data()['receiverId'],
            senderId: notifi.data()['senderId'],
            senderName: notifi.data()['senderName'],
            senderImg: notifi.data()['senderImg'],
            notificationTime: notifi.data()['notificationTime'],
            notificationMsg: notifi.data()['notificationMsg'],
            notificationPost: notifi.data()['notificationPost'],
            notificationEvent: notifi.data()['notificationEvent'],
          ),
        )
        .toList();

    return listOfNotification;
  }

  Stream<List<NotificationModel>> get getNotificationList {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Notification')
        .snapshots()
        .map(listOfNotification);
  }
}

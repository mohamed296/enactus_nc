import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:enactusnca/Models/event_model.dart';
import 'package:enactusnca/Models/messages_model.dart';
import 'package:enactusnca/Models/notification_model.dart';
import 'package:enactusnca/Models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;

class NotificationServices {
  String url =
      'http://www.enactusnewcairo.org/api/ncaapp/notifications/group/?';
  final user = FirebaseAuth.instance.currentUser;

  String notificationMsg({NotificationModel notificationModel, bool like}) {
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

  Future sendNotification(
      {NotificationModel notificationModel, bool like}) async {
    final String notificationMessage =
        notificationModel.notificationPost != null
            ? notificationMsg(notificationModel: notificationModel, like: like)
            : notificationModel.notificationMsg;
    final String notificationTime = formatDate(
      DateTime.now(),
      [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn],
    );
    final path = FirebaseFirestore.instance
        .collection('Users')
        .doc(notificationModel.receiverId)
        .collection('Notification')
        .doc();

    final addNotification = await path.set({
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

  Future<void> removeNotification({@required String notificationId}) async {
    final path = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Notification')
        .doc(notificationId);

    final item = await path.get();

    if (item.exists) {
      return item.reference.delete();
    }
  }

  List<NotificationModel> listOfNotification(QuerySnapshot snapshot) {
    final listOfNotification = snapshot.docs
        .map(
          (notifi) => NotificationModel(
            notificationId: notifi.id,
            receiverId: notifi.data()['receiverId'] as String,
            senderId: notifi.data()['senderId'] as String,
            senderName: notifi.data()['senderName'] as String,
            senderImg: notifi.data()['senderImg'] as String,
            notificationTime: notifi.data()['notificationTime'] as String,
            notificationMsg: notifi.data()['notificationMsg'] as String,
            notificationPost: notifi.data()['notificationPost'] as Post,
            notificationEvent: notifi.data()['notificationEvent'] as EventModel,
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

  Future<void> sendGetNotificationOto(MessageModel messageModel) async {
    String url;
    try {
      if (messageModel.type == 'Task' || messageModel.type == 'Message') {
        url =
            'http://www.enactusnewcairo.org/api/ncaapp/notifications/group/?auth-token=2d041ds81dsa5641dsa5611d6as5&senderid=${messageModel.senderId}&recid=${messageModel.receverId}&body=${messageModel.message}&notification-type=oto';
      } else {
        url =
            'http://www.enactusnewcairo.org/api/ncaapp/notifications/group/?auth-token=2d041ds81dsa5641dsa5611d6as5&senderid=${messageModel.senderId}&recid=${messageModel.receverId}&body=$Image&notification-type=oto';
      }
      await http.get(url);
    } catch (e) {
      return e;
    }
  }

  Future<void> sendGetnotificationGroup(MessageModel messageModel) async {
    String url;
    try {
      if (messageModel.type == 'Task' || messageModel.type == 'Message') {
        url =
            'http://www.enactusnewcairo.org/api/ncaapp/notifications/group/?auth-token=2d041ds81dsa5641dsa5611d6as5&senderid=${messageModel.senderId}&groupname=${messageModel.groupId}&body=${messageModel.message}&notification-type=group';
      } else {
        url =
            'http://www.enactusnewcairo.org/api/ncaapp/notifications/group/?auth-token=2d041ds81dsa5641dsa5611d6as5&senderid=${messageModel.senderId}&groupname=${messageModel.groupId}&body=$Image&notification-type=group';
      }
      await http.get(url);
    } catch (e) {
      return e;
    }
  }
}

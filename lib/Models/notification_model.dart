import 'package:enactusnca/Models/event_model.dart';
import 'package:enactusnca/Models/post.dart';

class NotificationModel {
  final String notificationId;
  final String senderId;
  final String receiverId;
  final String senderName;
  final String senderImg;
  final String notificationMsg;
  final String notificationTime;
  final Post notificationPost;
  final EventModel notificationEvent;

  NotificationModel({
    this.notificationId,
    this.senderId,
    this.receiverId,
    this.senderName,
    this.senderImg,
    this.notificationMsg,
    this.notificationTime,
    this.notificationPost,
    this.notificationEvent,
  });
}

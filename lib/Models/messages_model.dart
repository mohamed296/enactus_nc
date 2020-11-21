import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messageId;
  final String groupId;
  final String userId;
  final String userImg;
  final String userName;
  final String message;
  final Timestamp timestamp;
  final bool read;
  final String type;

  MessageModel({
    this.messageId,
    this.groupId,
    this.userId,
    this.userImg,
    this.userName,
    this.message,
    this.timestamp,
    this.type,
    this.read,
  });
}

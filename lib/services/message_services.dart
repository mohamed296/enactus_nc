import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Models/messages_model.dart';
import 'package:enactusnca/services/notification_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageServices {
  final user = FirebaseAuth.instance.currentUser;

  Future sendMessage(MessageModel messageModel) async {
    MessageModel message = MessageModel(
      senderId: user.uid,
      receverId: messageModel.receverId,
      userImg: user.photoURL,
      userName: user.displayName,
      groupId: messageModel.groupId,
      type: messageModel.type,
      message: messageModel.message,
    );
    Map<String, dynamic> messageData = {
      'groupId': messageModel.groupId,
      'senderId': user.uid,
      'receverId': messageModel.receverId,
      'userImg': user.photoURL,
      'userName': user.displayName,
      'message': messageModel.message,
      'timestamp': DateTime.now(),
      'type': messageModel.type,
      'read': false,
    };

    DocumentReference addMessage = await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(messageModel.groupId)
        .collection("chats")
        .add(messageData)
        .catchError((error) => print("getConversationErrors : ${error.toString()}"))
        .then((value) => NotificationServices().sendGetNotificationOto(message))
        .whenComplete(() => updateLastMessage(message));
    return addMessage;
  }

  Future updateLastMessage(MessageModel messageModel) async {
    String lastMessage;
    if (messageModel.type == 'Task' || messageModel.type == 'Message') {
      lastMessage = messageModel.message;
    } else {
      lastMessage = 'Image';
    }

    Map<String, dynamic> chatRoomData = {
      "lastSender": user.displayName,
      "lastMessage": lastMessage,
      "isRead": false,
      "lastTime": DateTime.now().millisecondsSinceEpoch,
      "chatroomid": messageModel.groupId,
    };
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(messageModel.groupId)
        .update(chatRoomData)
        .catchError((e) => print("update error " + e.toString()));
  }

  List<MessageModel> listOfMessages(QuerySnapshot snapshot) {
    var listOfMessages = snapshot.docs
        .map(
          (message) => MessageModel(
            messageId: message.id,
            groupId: message.data()['groupId'],
            message: message.data()['message'],
            timestamp: message.data()['timestamp'],
            type: message.data()['type'],
            senderId: message.data()['senderId'],
            receverId: message.data()['receverId'],
            userImg: message.data()['userImg'],
            userName: message.data()['userName'],
            read: message.data()['read'],
          ),
        )
        .toList();

    return listOfMessages;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/model/chat_details.dart';
import 'package:enactusnca/model/messages_model.dart';
import 'package:enactusnca/services/notification_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageServices {
  final user = FirebaseAuth.instance.currentUser;

  Future sendMessage(MessageModel messageModel) async {
    final MessageModel message = MessageModel(
      senderId: user.uid,
      receverId: messageModel.receverId,
      userImg: user.photoURL,
      userName: user.displayName,
      groupId: messageModel.groupId,
      type: messageModel.type,
      message: messageModel.message,
    );
    final Map<String, dynamic> messageData = {
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

    final DocumentReference addMessage = await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(messageModel.groupId)
        .collection("chats")
        .add(messageData)
        .then((value) => NotificationServices().sendGetNotificationOto(message))
        .whenComplete(() => updateLastMessage(message)) as DocumentReference;
    return addMessage;
  }

  Future<void> updateLastMessage(MessageModel messageModel) async {
    String lastMessage;
    if (messageModel.type == 'Task' || messageModel.type == 'Message') {
      lastMessage = messageModel.message;
    } else if (messageModel.type == 'Record') {
      lastMessage = 'Recored';
    } else {
      lastMessage = 'Image';
    }

    final Map<String, dynamic> chatRoomData = {
      "lastSender": user.displayName,
      "lastMessage": lastMessage,
      "isRead": false,
      "lastTime": DateTime.now().millisecondsSinceEpoch,
      "chatroomid": messageModel.groupId,
    };
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(messageModel.groupId)
        .update(chatRoomData);
  }

  List<MessageModel> listOfMessages(QuerySnapshot snapshot) => snapshot.docs
      .map(
        (message) => MessageModel(
          messageId: message.id,
          groupId: message.data()['groupId'] as String,
          message: message.data()['message'] as String,
          timestamp: message.data()['timestamp'] as Timestamp,
          type: message.data()['type'] as String,
          senderId: message.data()['senderId'] as String,
          receverId: message.data()['receverId'] as String,
          userImg: message.data()['userImg'] as String,
          userName: message.data()['userName'] as String,
          read: message.data()['read'] as bool,
        ),
      )
      .toList();

  List<ChatDetails> mapListOfChatDetails(QuerySnapshot snapshot) {
    return snapshot.docs
        .map(
          (chatDetails) => ChatDetails(
            chatroomid: chatDetails.data()['chatroomid'] as String,
            emails: chatDetails.data()['emails'] as List<dynamic>,
            ids: chatDetails.data()['ids'] as List<String>,
            isRead: chatDetails.data()['isRead'] as bool,
            users: chatDetails.data()['users'] as List<String>,
            lastTime: chatDetails.data()['lastTime'] as String,
            lastMessage: chatDetails.data()['lastMessage'] as String,
            lastSender: chatDetails.data()['lastSender'] as String,
          ),
        )
        .toList();
  }

  Stream<List<ChatDetails>> getChatRooms({String email}) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        // .where("emails", arrayContains: email)
        // .orderBy('lastTime', descending: true)
        .snapshots()
        .map(mapListOfChatDetails);
  }
}

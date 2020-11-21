import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:enactusnca/Models/messages_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageServices {
  final user = FirebaseAuth.instance.currentUser;

  Future sendMessage(MessageModel messageModel) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      Map<String, dynamic> messageData = {
        'groupId': messageModel.groupId,
        'userId': user.uid,
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
          .whenComplete(() => updateLastMessage(messageModel));
      return addMessage;
    }
    return null;
  }

  Future updateLastMessage(MessageModel messageModel) async {
    Map<String, dynamic> chatRoomData = {
      "lastSender": user.displayName,
      "lastMessage": messageModel.message,
      "isRead": false,
      "lastTime": DateTime.now().millisecondsSinceEpoch,
      "chatroomid": messageModel.groupId,
    };
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(messageModel.groupId)
        .update(chatRoomData)
        .catchError((e) => print("Uploading error " + e.toString()));
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
            userId: message.data()['userId'],
            userImg: message.data()['userImg'],
            userName: message.data()['userName'],
            read: message.data()['read'],
          ),
        )
        .toList();

    return listOfMessages;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Models/messages_group.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageGroupServices {
  final user = FirebaseAuth.instance.currentUser;

  Future sendMessage(MessageGroup messageGroup) async {
    User user = FirebaseAuth.instance.currentUser;
    return await FirebaseFirestore.instance
        .collection('GroupChat')
        .doc(messageGroup.groupId)
        .collection('messages')
        .doc()
        .set({
      'userId': user.uid,
      'userImg': user.photoURL,
      'userName': user.displayName,
      'groupId': messageGroup.groupId,
      'message': messageGroup.message,
      'timestamp': messageGroup.timestamp,
      'type': messageGroup.type,
    });
  }

  List<MessageGroup> listOfNotification(QuerySnapshot snapshot) {
    var listOfMessages = snapshot.docs
        .map(
          (message) => MessageGroup(
            id: message.id,
            groupId: message.data()['groupId'],
            message: message.data()['message'],
            timestamp: message.data()['timestamp'],
            type: message.data()['type'],
            userId: message.data()['userId'],
            userImg: message.data()['userImg'],
            userName: message.data()['userName'],
          ),
        )
        .toList();

    return listOfMessages;
  }
}

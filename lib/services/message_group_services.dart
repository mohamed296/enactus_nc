import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Models/list_of_groups.dart';
import 'package:enactusnca/Models/messages_model.dart';
import 'package:enactusnca/Models/notification_model.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/services/notification_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageGroupServices {
  final user = FirebaseAuth.instance.currentUser;

  Future sendGroupMessage(MessageModel messageModel) async {
    final MessageModel message = MessageModel(
      senderId: user.uid,
      receverId: messageModel.receverId,
      userImg: user.photoURL,
      userName: user.displayName,
      groupId: messageModel.groupId,
      type: messageModel.type,
      message: messageModel.message,
    );
    return FirebaseFirestore.instance
        .collection('GroupChat')
        .doc(messageModel.groupId)
        .collection(messageModel.groupId)
        .doc()
        .set(
      {
        'groupId': messageModel.groupId,
        'senderId': user.uid,
        'receverId': messageModel.receverId,
        'userImg': user.photoURL,
        'userName': user.displayName,
        'message': messageModel.message,
        'timestamp': DateTime.now(),
        'type': messageModel.type,
        'read': false,
      },
    ).then(
      (value) {
        NotificationServices().sendGetnotificationGroup(message);
        if (message.type == 'Task' || message.type == 'Message') {
          updateLastMessage(message.message, message.groupId);
        } else {
          updateLastMessage('Image', message.groupId);
        }
      },
    );
  }

  Future sendTaskMessage({MessageModel messageModel, DateTime dateTime, bool sendNotifi}) async {
    final NotificationModel notificationModel = NotificationModel(
      notificationMsg: 'Task Assigned To You, DeadLine: ${dateTime.toString()}',
      receiverId: messageModel.senderId,
    );
    return FirebaseFirestore.instance
        .collection('GroupChat')
        .doc(messageModel.groupId)
        .collection(messageModel.groupId)
        .doc()
        .set(
      {
        'groupId': messageModel.groupId,
        'senderId': messageModel.senderId,
        'receverId': messageModel.receverId,
        'userImg': messageModel.userImg,
        'userName': messageModel.userName,
        'message': dateTime.toString(),
        'timestamp': DateTime.now(),
        'type': 'Task',
        'read': false,
      },
    ).whenComplete(() {
      if (sendNotifi) {
        NotificationServices().sendNotification(notificationModel: notificationModel, like: false);
      }
    });
  }

  Future createGroupChatOrAddNewMember(String groupName, UserModel userModel) async {
    final groupData = await FirebaseFirestore.instance.collection('GroupChat').doc(groupName).get();

    if (groupData.exists) {
      addNewMemberToGroupChat(groupName, userModel);
    } else {
      createNewGroupChat(groupName).whenComplete(() {
        addNewMemberToGroupChat(groupName, userModel);
      });
    }
  }

  Future getGroupData(String groupName) =>
      FirebaseFirestore.instance.collection('GroupChat').doc(groupName).get();

  Future updateLastMessage(String lastMessage, String groupName) async => FirebaseFirestore.instance
      .collection('GroupChat')
      .doc(groupName)
      .update({'lastMessage': lastMessage});

  Future createNewGroupChat(String groupName) async =>
      FirebaseFirestore.instance.collection('GroupChat').doc(groupName).set(
        {
          'groupId': groupName,
          'groupName': groupName,
          'groupImg': null,
          'lastMessage': null,
        },
      );

  Future addNewMemberToGroupChat(String groupName, UserModel userModel) async =>
      FirebaseFirestore.instance
          .collection('GroupChat')
          .doc(groupName)
          .collection('members')
          .doc(userModel.id)
          .set(
        {
          'id': userModel.id,
          'userName': userModel.username,
          'isActive': userModel.isActive,
          'isHead': userModel.isHead,
          'isAdmin': userModel.isAdmin,
          'email': userModel.email,
          'photoUrl': userModel.photoUrl,
          'groupName': groupName,
        },
      );

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

  List<ListOfGroups> listOfGroups(QuerySnapshot snapshot) => snapshot.docs
      .map(
        (group) => ListOfGroups(
          id: group.id,
          groupName: group.data()['groupName'] as String,
          groupImg: group.data()['groupImg'] as String,
          groupId: group.data()['groupId'] as String,
          lastMessage: group.data()['lastMessage'] as String,
        ),
      )
      .toList();

  List<UserModel> listOfMembers(QuerySnapshot snapshot) => snapshot.docs
      .map(
        (member) => UserModel(
          id: member.id,
          photoUrl: member.data()['photoUrl'] as String,
          email: member.data()['email'] as String,
          username: member.data()['userName'] as String,
          isHead: member.data()['isHead'] as bool,
          isAdmin: member.data()['isAdmin'] as bool,
        ),
      )
      .toList();

  Stream<List<ListOfGroups>> get getGroupsList =>
      FirebaseFirestore.instance.collection('GroupChat').snapshots().map(listOfGroups);
}

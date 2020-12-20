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
    MessageModel message = MessageModel(
      senderId: user.uid,
      receverId: messageModel.receverId,
      userImg: user.photoURL,
      userName: user.displayName,
      groupId: messageModel.groupId,
      type: messageModel.type,
      message: messageModel.message,
    );
    return await FirebaseFirestore.instance
        .collection('GroupChat')
        .doc(messageModel.groupId)
        .collection(messageModel.groupId)
        .doc()
        .set({
      'groupId': messageModel.groupId,
      'senderId': user.uid,
      'receverId': messageModel.receverId,
      'userImg': user.photoURL,
      'userName': user.displayName,
      'message': messageModel.message,
      'timestamp': DateTime.now(),
      'type': messageModel.type,
      'read': false,
    }).then(
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

  Future sendTaskMessage(
    MessageModel messageModel,
    DateTime dateTime,
    bool sendNotification,
  ) async {
    final NotificationModel notificationModel = NotificationModel(
      notificationMsg: 'Task Assigned To You, DeadLine: ${dateTime.toString()}',
      receiverId: messageModel.senderId,
    );
    return await FirebaseFirestore.instance
        .collection('GroupChat')
        .doc(messageModel.groupId)
        .collection(messageModel.groupId)
        .doc()
        .set({
      'groupId': messageModel.groupId,
      'senderId': messageModel.senderId,
      'receverId': messageModel.receverId,
      'userImg': messageModel.userImg,
      'userName': messageModel.userName,
      'message': dateTime.toString(),
      'timestamp': DateTime.now(),
      'type': 'Task',
      'read': false,
    }).whenComplete(() {
      if (sendNotification) NotificationServices().sendNotification(notificationModel, false);
    });
  }

  Future createGroupChatOrAddNewMember(String groupName, UserModel userModel) async {
    var groupData = await FirebaseFirestore.instance.collection('GroupChat').doc(groupName).get();

    if (groupData.exists) {
      addNewMemberToGroupChat(groupName, userModel);
    } else {
      createNewGroupChat(groupName).whenComplete(() {
        addNewMemberToGroupChat(groupName, userModel);
      });
    }
  }

  Future getGroupData(String groupName) async {
    return await FirebaseFirestore.instance.collection('GroupChat').doc(groupName).get();
  }

  Future updateLastMessage(String lastMessage, String groupName) async {
    return await FirebaseFirestore.instance
        .collection('GroupChat')
        .doc(groupName)
        .update({'lastMessage': lastMessage});
  }

  Future createNewGroupChat(String groupName) async {
    return await FirebaseFirestore.instance.collection('GroupChat').doc(groupName).set({
      'groupId': groupName,
      'groupName': groupName,
      'groupImg': null,
      'lastMessage': null,
    });
  }

  Future addNewMemberToGroupChat(String groupName, UserModel userModel) async {
    return await FirebaseFirestore.instance
        .collection('GroupChat')
        .doc(groupName)
        .collection('members')
        .doc(userModel.id)
        .set({
      'id': userModel.id,
      'userName': userModel.username,
      'isActive': userModel.isActive,
      'isHead': userModel.isHead,
      'isAdmin': userModel.isAdmin,
      'email': userModel.email,
      'photoUrl': userModel.photoUrl,
      'groupName': groupName,
    });
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

  List<ListOfGroups> listOfGroups(QuerySnapshot snapshot) {
    var listOfGroups = snapshot.docs
        .map(
          (group) => ListOfGroups(
            id: group.id,
            groupName: group.data()['groupName'],
            groupImg: group.data()['groupImg'],
            groupId: group.data()['groupId'],
            lastMessage: group.data()['lastMessage'],
          ),
        )
        .toList();

    return listOfGroups;
  }

  List<UserModel> listOfMembers(QuerySnapshot snapshot) {
    var listOfMembers = snapshot.docs
        .map(
          (member) => UserModel(
            id: member.id,
            photoUrl: member.data()['photoUrl'],
            email: member.data()['email'],
            username: member.data()['userName'],
            isHead: member.data()['isHead'],
            isAdmin: member.data()['isAdmin'],
          ),
        )
        .toList();

    return listOfMembers;
  }

  Stream<List<ListOfGroups>> get getGroupsList {
    return FirebaseFirestore.instance.collection('GroupChat').snapshots().map(listOfGroups);
  }
}

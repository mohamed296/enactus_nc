import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  uploadUserInfo(userMap) {
    Firestore.instance.collection("Users").add(userMap).catchError((e) {
      print("Uploading error " + e.toString());
    });
  }

  changeIsLiked(bool newVal, String roomId, String messageId) {
    Firestore.instance
        .collection("chatRoom")
        .document(roomId)
        .collection("chats")
        .document(messageId)
        .updateData({'isLiked': newVal}).catchError((e) {
      print("Uploading error " + e.toString());
    });
  }

  getUsersByUserEmail(String email) async {
    return await Firestore.instance
        .collection("Users")
        .where("email", isEqualTo: email)
        .getDocuments();
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((error) {
      print("chatRoom error: ${error.toString()}");
    });
  }

  addConversationMessages({String chatRoomId, chatConversationMap}) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .updateData(chatConversationMap)
        .catchError((e) {
      print("Uploading error " + e.toString());
    });
  }

  markMessageAsSeen(String chatRoomId) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .updateData({'isRead': true}).catchError((e) {
      print("Uploading error " + e.toString());
    });
  }

  getConversationMessages({String chatRoomId}) async {
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  getChatRooms({String userName}) async {
    return Firestore.instance
        .collection("chatRoom")
        .where("users", arrayContains: userName)
        .orderBy('lastTime', descending: true)
        .snapshots();
  }

  getUsers() async {
    return Firestore.instance.collection("Users").snapshots();
  }
}

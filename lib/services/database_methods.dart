import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("Users").add(userMap).catchError((e) {
      print("Uploading error " + e.toString());
    });
  }

  changeIsLiked(bool newVal, String roomId, String messageId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(roomId)
        .collection("chats")
        .doc(messageId)
        .update({'isLiked': newVal}).catchError((e) {
      print("Uploading error " + e.toString());
    });
  }

  getUsersByUserEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("email", isEqualTo: email)
        .get();
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((error) {
      print("chatRoom error: ${error.toString()}");
    });
  }

  addConversationMessages({String chatRoomId, chatConversationMap}) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .update(chatConversationMap)
        .catchError((e) {
      print("Uploading error " + e.toString());
    });
  }

  markMessageAsSeen(String chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .update({'isRead': true}).catchError((e) {
      print("Uploading error " + e.toString());
    });
  }

  getConversationMessages({String chatRoomId}) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  getChatRooms({String email}) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where("emails", arrayContains: email)
        .orderBy('lastTime', descending: true)
        .snapshots();
  }

  getUsers() async {
    return FirebaseFirestore.instance.collection("Users").snapshots();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Models/user_model.dart';

class DatabaseMethods {
  Future uploadUserInfo({UserModel userModel, String uid}) async {
    return await FirebaseFirestore.instance.collection("Users").doc(uid).set({
      "firstName": userModel.firstName,
      "lastName": userModel.lastName,
      "department": userModel.department,
      "community": userModel.community,
      "email": userModel.email,
      "photoUrl": userModel.photoUrl,
      "uid": uid,
      "isActive": false,
      "isHead": false,
      'isAdmin': false,
      "joiningDate": DateTime.now(),
      'userName': '${userModel.firstName}${userModel.lastName}',
    }).catchError((e) {
      print("Uploading error " + e.toString());
    });
  }

  Future<String> checkUserActivate(String id) async {
    final path = FirebaseFirestore.instance.collection("Users").doc(id);
    final user = await path.get();

    if (user.exists == true) {
      bool isActive = await user.data()['isActive'];
      if (isActive) return 'Active';
      return 'Your account still pending Approval';
    } else {
      return 'this user does not exist';
    }
  }

  Future getUserData(String id) async {
    return await FirebaseFirestore.instance.collection("Users").doc(id).get();
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

  createChatRoom(String chatRoomId, chatRoomMap) async {
    return await FirebaseFirestore.instance
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

  getChatRooByRoomId({String roomId}) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where("chatroomid", isEqualTo: roomId)
        .orderBy('lastTime', descending: true)
        .get();
  }

  getUsers() async {
    return FirebaseFirestore.instance.collection("Users").snapshots();
  }
}

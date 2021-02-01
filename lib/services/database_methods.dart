import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Models/user_model.dart';

class DatabaseMethods {
  Future uploadUserInfo({UserModel userModel, String uid}) async {
    return FirebaseFirestore.instance.collection("Users").doc(uid).set(
      {
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
        'userName': '${userModel.firstName} ${userModel.lastName}',
      },
    );
  }

  Future<String> checkUserActivate(String id) async {
    final path = FirebaseFirestore.instance.collection("Users").doc(id);
    final user = await path.get();

    if (user.exists == true) {
      final bool isActive = await user.data()['isActive'] as bool;
      if (isActive) return 'Active';
      return 'Your account still pending Approval';
    } else {
      return 'this user does not exist';
    }
  }

  Future<DocumentSnapshot> getUserData(String id) {
    return FirebaseFirestore.instance.collection("Users").doc(id).get();
  }

  Future<void> changeIsLiked({bool newVal, String roomId, String messageId}) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(roomId)
        .collection("chats")
        .doc(messageId)
        .update({'isLiked': newVal});
  }

  Future<QuerySnapshot> getUsersByUserEmail(String email) {
    return FirebaseFirestore.instance.collection("Users").where("email", isEqualTo: email).get();
  }

  Future<void> createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomMap) {
    return FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomId).set(chatRoomMap);
  }

  Future<void> addConversationMessages({String chatRoomId, chatConversationMap}) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .update(chatConversationMap);
  }

  Future<void> markMessageAsSeen(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .update({'isRead': true});
  }

  Future<Stream<QuerySnapshot>> getConversationMessages({String chatRoomId}) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms({String email}) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where("emails", arrayContains: email)
        .orderBy('lastTime', descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> getChatRooByRoomId({String roomId}) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where("chatroomid", isEqualTo: roomId)
        .orderBy('lastTime', descending: true)
        .get();
  }

  Future<Stream<QuerySnapshot>> getUsers() async {
    return FirebaseFirestore.instance.collection("Users").snapshots();
  }
}

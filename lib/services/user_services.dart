import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/model/user_model.dart';
import 'package:enactusnca/services/message_group_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServices {
  final user = FirebaseAuth.instance.currentUser;

  Future updateUserData(UserModel userModel) => FirebaseFirestore.instance
      .collection('Users')
      .doc(user.uid)
      .update(
        {
          "firstName": userModel.firstName,
          "lastName": userModel.lastName,
          'userName': '${userModel.firstName} ${userModel.lastName}',
          "email": userModel.email,
          "photoUrl": userModel.photoUrl,
          "community": userModel.community,
          "department": userModel.department,
        },
      )
      .then(
        (value) => user.updateProfile(
          displayName: userModel.username,
          photoURL: userModel.photoUrl,
        ),
      )
      .whenComplete(() {
        MessageGroupServices().createGroupChatOrAddNewMember(userModel.community, userModel);
        MessageGroupServices().createGroupChatOrAddNewMember(userModel.department, userModel);
      });

  UserModel userData(DocumentSnapshot snapshot) => UserModel(
        id: snapshot.id,
        firstName: snapshot.data()['firstName'] as String,
        lastName: snapshot.data()['lastName'] as String,
        username: snapshot.data()['userName'] as String,
        email: snapshot.data()['email'] as String,
        photoUrl: snapshot.data()['photoUrl'] as String,
        joiningDate: snapshot.data()['joiningDate'] as Timestamp,
        community: snapshot.data()['community'] as String,
        department: snapshot.data()['department'] as String,
        isActive: snapshot.data()['isActive'] as bool,
        isHead: snapshot.data()['isHead'] as bool,
        isAdmin: snapshot.data()['isAdmin'] as bool,
      );

  List<UserModel> getListOfUsers(QuerySnapshot snapshot) {
    return snapshot.docs.map((user) {
      return UserModel(
        id: user.id,
        firstName: user.data()['firstName'] as String,
        lastName: user.data()['lastName'] as String,
        username: user.data()['userName'] as String,
        email: user.data()['email'] as String,
        photoUrl: user.data()['photoUrl'] as String,
        joiningDate: user.data()['joiningDate'] as Timestamp,
        community: user.data()['community'] as String,
        department: user.data()['department'] as String,
        isActive: user.data()['isActive'] as bool,
        isHead: user.data()['isHead'] as bool,
        isAdmin: user.data()['isAdmin'] as bool,
      );
    }).toList();
  }

  Stream<List<UserModel>> getUsers() {
    return FirebaseFirestore.instance
        .collection("Users")
        .snapshots()
        .map(UserServices().getListOfUsers);
  }
}

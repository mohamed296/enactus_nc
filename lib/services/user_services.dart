import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Models/user_model.dart';
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
}

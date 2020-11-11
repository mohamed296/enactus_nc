import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/services/message_group_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServices {
  final user = FirebaseAuth.instance.currentUser;

  Future updateUserData(UserModel userModel) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .update({
          "firstName": userModel.firstName,
          "lastName": userModel.lastName,
          'userName': '${userModel.firstName} ${userModel.lastName}',
          "email": userModel.email,
          "photoUrl": userModel.photoUrl,
          "community": userModel.community,
          "department": userModel.department,
        })
        .then(
          (value) => user.updateProfile(
            displayName: userModel.username,
            photoURL: userModel.photoUrl,
          ),
        )
        .whenComplete(() {
          MessageGroupServices()
              .createGroupChatOrAddNewMember(userModel.community, userModel);
          MessageGroupServices()
              .createGroupChatOrAddNewMember(userModel.department, userModel);
        });
  }

  UserModel userData(DocumentSnapshot snapshot) {
    return UserModel(
      id: snapshot.id,
      firstName: snapshot.data()['firstName'],
      lastName: snapshot.data()['lastName'],
      username: snapshot.data()['userName'],
      email: snapshot.data()['email'],
      photoUrl: snapshot.data()['photoUrl'],
      joiningDate: snapshot.data()['joiningDate'],
      community: snapshot.data()['community'],
      department: snapshot.data()['department'],
      isActive: snapshot.data()['isActive'],
      isHead: snapshot.data()['isHead'],
    );
  }
}

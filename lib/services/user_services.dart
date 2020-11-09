import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServices {
  final user = FirebaseAuth.instance.currentUser;

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

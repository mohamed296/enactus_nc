import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;
  final String imageUrl;
  final int idd;

  User({
    this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
    this.imageUrl,
    this.idd,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      email: doc['email'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
      displayName: doc['displayName'],
      bio: doc['bio'],
    );
  }

  Function(DocumentSnapshot event) get getUserData => null;
}

class UserTitle {
  final String userId;
  final String name;
  /*final String imageUrl;
  final String state;*/

  UserTitle({this.userId, this.name});
}

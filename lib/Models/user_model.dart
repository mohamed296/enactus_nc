import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String photoUrl;
  final String department;
  final String community;
  final Timestamp joiningDate;
  final bool isActive;
  final bool isHead;
  final bool isAdmin;

  UserModel({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.photoUrl,
    this.department,
    this.community,
    this.joiningDate,
    this.isActive,
    this.isHead,
    this.isAdmin,
  });
}

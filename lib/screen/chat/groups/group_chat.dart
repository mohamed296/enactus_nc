import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/model/user_model.dart';
import 'package:enactusnca/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'admin_groups.dart';
import 'member_groups.dart';

class GroupChat extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .snapshots()
          .map(UserServices().userData),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isAdmin == true) {
            return AdminGroups(userModel: snapshot.data);
          } else {
            return MemberGroups(userModel: snapshot.data);
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/Screens/chat/groups/admin_groups.dart';
import 'package:enactusnca/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        return snapshot.hasData
            ? snapshot.data.isHead == true
                ? AdminGroups(userModel: snapshot.data)
                : MemberGroups(userModel: snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

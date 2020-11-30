import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/services/message_group_services.dart';
import 'package:flutter/material.dart';

class GroupMember extends StatelessWidget {
  final String groupName;

  const GroupMember({Key key, this.groupName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Member', style: TextStyle(color: KSacandColor)),
        leading: BackButton(),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: FirebaseFirestore.instance
            .collection('GroupChat')
            .doc(groupName)
            .collection('members')
            .snapshots()
            .map(MessageGroupServices().listOfMembers),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(
                            isAppBarEnabled: true,
                            userId: snapshot.data[index].id,
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: snapshot.data[index].photoUrl == null
                          ? AssetImage("assets/images/person.png")
                          : NetworkImage(snapshot.data[index].photoUrl),
                    ),
                    title: Text(snapshot?.data[index]?.username ?? 'user'),
                    subtitle: snapshot.data[index].isHead ? Text('Head') : Text('Member'),
                  ),
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

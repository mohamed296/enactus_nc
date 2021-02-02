import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/model/user_model.dart';
import 'package:enactusnca/screen/chat/messages/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'group_tile.dart';

class MemberGroups extends StatefulWidget {
  final UserModel userModel;

  const MemberGroups({Key key, this.userModel}) : super(key: key);
  @override
  _MemberGroupsState createState() => _MemberGroupsState();
}

class _MemberGroupsState extends State<MemberGroups> {
  final user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot communityData;
  DocumentSnapshot departmentData;
  DocumentSnapshot enactusData;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    final CollectionReference _groupchat = FirebaseFirestore.instance.collection('GroupChat');
    final communityGitingData = await _groupchat.doc(widget.userModel.community).get();
    setState(() => communityData = communityGitingData);

    if (widget.userModel.department != null) {
      final departmentGitingData = await _groupchat.doc(widget.userModel.department).get();
      setState(() => departmentData = departmentGitingData);
    }
    final enactusGitingData = await _groupchat.doc('Enactus NC').get();
    setState(() => enactusData = enactusGitingData);
  }

  @override
  Widget build(BuildContext context) {
    return enactusData == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12.0),
                GroupTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Messages(
                        group: true,
                        groupName: 'Enactus NC',
                        userId: widget.userModel.department,
                      ),
                    ),
                  ),
                  lastMessage: '${enactusData['lastMessage']}',
                  groupName: 'Enactus NC',
                ),
                const SizedBox(height: 12.0),
                GroupTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Messages(
                        group: true,
                        userId: widget.userModel.department,
                        groupName: widget.userModel.community,
                      ),
                    ),
                  ),
                  lastMessage: '${communityData['lastMessage']}',
                  groupName: widget.userModel.community,
                ),
                const SizedBox(height: 12.0),
                if (widget.userModel.department != null)
                  GroupTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Messages(
                          group: true,
                          userId: widget.userModel.department,
                          groupName: widget.userModel.department,
                        ),
                      ),
                    ),
                    lastMessage: '${departmentData['lastMessage']}',
                    groupName: widget.userModel.department,
                  )
                else
                  Container(),
              ],
            ),
          );
  }
}

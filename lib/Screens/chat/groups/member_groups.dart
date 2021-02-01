import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/Screens/chat/messages/messages.dart';
import 'package:enactusnca/controller/message_group_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    final CollectionReference _groupchat =
        FirebaseFirestore.instance.collection('GroupChat');
    final communityGitingData =
        await _groupchat.doc(widget.userModel.community).get();
    setState(() => communityData = communityGitingData);

    if (widget.userModel.department != null) {
      final departmentGitingData =
          await _groupchat.doc(widget.userModel.department).get();
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
                FutureBuilder<bool>(
                  future: MessageGroupController()
                      .getMessageCountChange('Enactus NC'),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? const Center(child: CircularProgressIndicator())
                        : Container(
                            margin: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0,
                              right: 20.0,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            decoration: BoxDecoration(
                              color: Constants.midBlue,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: ListTile(
                              leading: Badge(
                                showBadge: snapshot.data,
                                badgeContent: const Text(''),
                                badgeColor: Constants.yellow,
                                // ignore: sized_box_for_whitespace
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(34.0),
                                    child: Image.asset(
                                        'assets/images/enactus.png'),
                                  ),
                                ),
                              ),
                              title: const Text('Enactus NC'),
                              subtitle: Text('${enactusData['lastMessage']}',
                                  maxLines: 1),
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
                            ),
                          );
                  },
                ),
                FutureBuilder<bool>(
                  future: MessageGroupController()
                      .getMessageCountChange(widget.userModel.community),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? const Center(child: CircularProgressIndicator())
                        : Container(
                            margin: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0,
                              right: 20.0,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 20.0,
                            ),
                            decoration: BoxDecoration(
                              color: Constants.midBlue,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: ListTile(
                              leading: Badge(
                                showBadge: snapshot.data,
                                badgeContent: const Text(''),
                                badgeColor: Constants.yellow,
                                child: SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(34.0),
                                    child: Image.asset(
                                        'assets/images/enactus.png'),
                                  ),
                                ),
                              ),
                              title: Text(widget.userModel.community),
                              subtitle: Text('${communityData['lastMessage']}',
                                  maxLines: 1),
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
                            ),
                          );
                  },
                ),
                if (widget.userModel.department != null)
                  FutureBuilder<bool>(
                    future: MessageGroupController()
                        .getMessageCountChange(widget.userModel.department),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? const Center(child: CircularProgressIndicator())
                          : Container(
                              margin: const EdgeInsets.only(
                                top: 5.0,
                                bottom: 5.0,
                                right: 20.0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              decoration: BoxDecoration(
                                color: Constants.midBlue,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: ListTile(
                                leading: FutureBuilder<bool>(
                                    future: MessageGroupController()
                                        .getMessageCountChange(
                                            widget.userModel.department),
                                    builder: (context, snapshot) {
                                      return !snapshot.hasData
                                          ? Center(child: Container())
                                          : Badge(
                                              showBadge: snapshot.data,
                                              badgeContent: const Text(''),
                                              badgeColor: Constants.yellow,
                                              child: SizedBox(
                                                height: 28,
                                                width: 28,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          34.0),
                                                  child: Image.asset(
                                                      'assets/images/enactus.png'),
                                                ),
                                              ),
                                            );
                                    }),
                                title: Text(widget.userModel.department),
                                subtitle: Text(
                                    '${departmentData['lastMessage']}',
                                    maxLines: 1),
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
                              ),
                            );
                    },
                  )
                else
                  Container(),
              ],
            ),
          );
  }
}

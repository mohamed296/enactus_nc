import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/Screens/chat/messages/messages.dart';
import 'package:flutter/material.dart';

class MemberGroups extends StatefulWidget {
  final UserModel userModel;

  const MemberGroups({Key key, this.userModel}) : super(key: key);
  @override
  _MemberGroupsState createState() => _MemberGroupsState();
}

class _MemberGroupsState extends State<MemberGroups> {
  DocumentSnapshot communityData;
  DocumentSnapshot departmentData;
  DocumentSnapshot enactusData;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    final communityGitingData = await FirebaseFirestore.instance
        .collection('GroupChat')
        .doc(widget.userModel.community)
        .get();
    setState(() => communityData = communityGitingData);

    if (widget.userModel.department != null) {
      final departmentGitingData = await FirebaseFirestore.instance
          .collection('GroupChat')
          .doc(widget.userModel.department)
          .get();
      setState(() => departmentData = departmentGitingData);
    }
    final enactusGitingData =
        await FirebaseFirestore.instance.collection('GroupChat').doc('Enactus NC').get();
    setState(() => enactusData = enactusGitingData);
  }

  @override
  Widget build(BuildContext context) {
    return enactusData == null
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(34.0),
                    child: Container(
                      color: Colors.yellow,
                      height: 44,
                      width: 44,
                    ),
                  ),
                  title: Text('Enactus NC'),
                  subtitle: Text('${enactusData['lastMessage']}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Messages(
                        group: true,
                        groupName: 'Enactus NC',
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(34.0),
                    child: Container(
                      color: Colors.yellow,
                      height: 44,
                      width: 44,
                    ),
                  ),
                  title: Text(widget.userModel.community),
                  subtitle: Text('${communityData['lastMessage']}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Messages(
                        group: true,
                        groupName: widget.userModel.community,
                      ),
                    ),
                  ),
                ),
                widget.userModel.department != null
                    ? ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(34.0),
                          child: Container(
                            color: Colors.yellow,
                            height: 44,
                            width: 44,
                          ),
                        ),
                        title: Text(widget.userModel.department),
                        subtitle: Text('${departmentData['lastMessage']}'),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Messages(
                              group: true,
                              groupName: widget.userModel.department,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
  }
}

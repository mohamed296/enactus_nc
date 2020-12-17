import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
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
                Container(
                  margin: EdgeInsets.only(
                    top: 5.0,
                    bottom: 5.0,
                    right: 20.0,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Constants.midBlue,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      height: 35,
                      width: 35,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(34.0),
                        child: Image.asset('assets/images/enactus.png'),
                      ),
                    ),
                    title: Text('Enactus NC'),
                    subtitle: Text('${enactusData['lastMessage']}', maxLines: 1),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Messages(group: true, groupName: 'Enactus NC'),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 5.0,
                    bottom: 5.0,
                    right: 20.0,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Constants.midBlue,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      height: 35,
                      width: 35,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(34.0),
                        child: Image.asset('assets/images/enactus.png'),
                      ),
                    ),
                    title: Text(widget.userModel.community),
                    subtitle: Text('${communityData['lastMessage']}', maxLines: 1),
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
                ),
                widget.userModel.department != null
                    ? Container(
                        margin: EdgeInsets.only(
                          top: 5.0,
                          bottom: 5.0,
                          right: 20.0,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                        decoration: BoxDecoration(
                          color: Constants.midBlue,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: ListTile(
                          leading: Container(
                            height: 35,
                            width: 35,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(34.0),
                              child: Image.asset('assets/images/enactus.png'),
                            ),
                          ),
                          title: Text(widget.userModel.department),
                          subtitle: Text('${departmentData['lastMessage']}', maxLines: 1),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Messages(
                                group: true,
                                groupName: widget.userModel.department,
                              ),
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

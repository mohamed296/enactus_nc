import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/functions.dart';
import 'package:enactusnca/Models/recent_chat.dart';
import 'package:enactusnca/Screens/chat/messages/messages.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecentChat extends StatefulWidget {
  @override
  _RecentChatState createState() => _RecentChatState();
}

class _RecentChatState extends State<RecentChat> {
  List<RecentCh> recent = new List();
  Auth authMethods = new Auth();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;
  bool isLoadingOver = false;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    setState(() {
      print("${user.displayName}");
    });

    getUserInfo();
  }

  Widget emptyView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/emptychat.png"),
          SizedBox(
            height: 5,
          ),
          Text(
            'your chat list is empty ',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ],
      ),
    );
  }

  getUserInfo() async {
    databaseMethods.getChatRooms(email: user.email).then((val) {
      setState(() {
        chatRoomStream = val;
      });
    });
    isLoadingOver = true;
    setState(() {});
  }

  Widget contactsList(snapshot) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: snapshot.data.documents.length,
      itemBuilder: (context, index) {
        List users = snapshot.data.documents[index].data()["users"];
        String roomID = snapshot.data.documents[index].data()["chatroomid"];
        List emails = snapshot.data.documents[index].data()['emails'];
        List ids = snapshot.data.documents[index].data()['ids'];
        String imgURL;
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Messages(
                  group: false,
                  chatRoomId: roomID,
                  imageUrl: imgURL,
                  userId: ids[0] == user.uid ? ids[1] : ids[0],
                  lastSender: snapshot.data.documents[index].data()["lastSender"],
                  username: users[1] == user.displayName ? users[0] : users[1],
                  read: snapshot.data.documents[index].data()['isRead'],
                  lastmassage: snapshot.data.documents[index].data()["lastMessage"],
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(top: .0, bottom: 6.0, right: 20.0),
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color:

                  //  snapshot.data.documents[index].data()["lastSender"] != user.displayName
                  //     ? !snapshot.data.documents[index].data()["isRead"]
                  //         ? Constants.midBlue
                  //         : Constants.darkBlue
                  //     :
                  Constants.midBlue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FutureBuilder<dynamic>(
                  future: Constants.myEmail == emails[0]
                      ? databaseMethods.getUsersByUserEmail(emails[1])
                      : databaseMethods.getUsersByUserEmail(emails[0]),
                  builder: (context, newSnap) {
                    QuerySnapshot querySnapshot = newSnap.data;
                    imgURL = querySnapshot.docs[0].data()["photoUrl"];
                    return !newSnap.hasData
                        ? Center(child: CircularProgressIndicator())
                        : Badge(
                            badgeColor: Constants.yellow,
                            showBadge: !snapshot.data.documents[index].data()["isRead"],
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: imgURL == null
                                  ? AssetImage('assets/images/person.png')
                                  : NetworkImage(imgURL),
                              radius: 28.0,
                            ),
                          );
                  },
                ),
                SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      users[0] == user.displayName ? users[1] : users[0],
                      style: TextStyle(
                        color: Colors.grey.shade200,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Text(
                        snapshot.data.documents[index].data()["lastMessage"] == null
                            ? ""
                            : snapshot.data.documents[index].data()["lastSender"] ==
                                    user.displayName
                                ? 'You: ${snapshot.data.documents[index].data()["lastMessage"]}'
                                : '${snapshot.data.documents[index].data()["lastMessage"]}',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.blueGrey.shade200,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  Functions.readTimestamp(
                    snapshot.data.documents[index].data()["lastTime"] == null
                        ? 0
                        : snapshot.data.documents[index].data()["lastTime"],
                  ),
                  style: TextStyle(
                    color: Colors.grey.shade100,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget createChatContacts() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;
            default:
              return snapshot.hasData ? contactsList(snapshot) : emptyView();
              break;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
        ),
        child: createChatContacts(),
      ),
    );
  }
}

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/constant/constants.dart' as constants;
import 'package:enactusnca/services/auth.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:enactusnca/services/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'messages.dart';

class RecentChat extends StatefulWidget {
  @override
  _RecentChatState createState() => _RecentChatState();
}

class _RecentChatState extends State<RecentChat> {
  List<RecentChat> recent = [];
  Auth authMethods = Auth();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream chatRoomStream;
  bool isLoadingOver = false;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Widget emptyView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/emptychat.png"),
          const SizedBox(height: 6.0),
          const Text(
            'your chat list is empty ',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> getUserInfo() async {
    databaseMethods.getChatRooms(email: user.email).then((val) {
      setState(() => chatRoomStream = val);
    });
    isLoadingOver = true;
    setState(() {});
  }

  Widget contactsList(AsyncSnapshot<dynamic> snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: snapshot.data.documents.length as int,
      itemBuilder: (context, index) {
        final List users = snapshot.data.documents[index].data()["users"] as List;
        final String roomID = snapshot.data.documents[index].data()["chatroomid"] as String;
        final List emails = snapshot.data.documents[index].data()['emails'] as List;
        final List ids = snapshot.data.documents[index].data()['ids'] as List;
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
                  userId: ids[0] == user.uid ? ids[1] as String : ids[0] as String,
                  lastSender: snapshot.data.documents[index].data()["lastSender"] as String,
                  username: users[1] == user.displayName ? users[0] as String : users[1] as String,
                  read: snapshot.data.documents[index].data()['isRead'] as bool,
                  lastmassage: snapshot.data.documents[index].data()["lastMessage"] as String,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 6.0, right: 20.0),
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: constants.midBlue,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FutureBuilder<dynamic>(
                  future: constants.myEmail == emails[0]
                      ? databaseMethods.getUsersByUserEmail(emails[1] as String)
                      : databaseMethods.getUsersByUserEmail(emails[0] as String),
                  builder: (context, newSnap) {
                    final QuerySnapshot querySnapshot = newSnap.data as QuerySnapshot;
                    imgURL = querySnapshot.docs[0].data()["photoUrl"] as String;
                    if (!newSnap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Badge(
                        badgeColor: constants.yellow,
                        showBadge: snapshot.data.documents[index].data()["isRead"] as bool,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: imgURL == null
                              ? const AssetImage('assets/images/person.png') as ImageProvider
                              : NetworkImage(imgURL),
                          radius: 28.0,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      users[0] == user.displayName ? users[1] as String : users[0] as String,
                      style: TextStyle(
                        color: Colors.grey.shade200,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
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
                const Spacer(),
                Text(
                  Functions.readTimestamp(
                    snapshot.data.documents[index].data()["lastTime"] as int ?? 0,
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
            return const Center(child: CircularProgressIndicator());
            break;
          default:
            return snapshot.hasData ? contactsList(snapshot) : emptyView();
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
        ),
        child: createChatContacts(),
      ),
    );
  }
}

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/model/user_model.dart';
import 'package:enactusnca/screen/chat/messages/messages.dart';
import 'package:enactusnca/services/functions.dart';
import 'package:enactusnca/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:enactusnca/constant/constants.dart' as constants;

class ChatTile extends StatefulWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final int index;

  const ChatTile({
    Key key,
    this.snapshot,
    this.index,
  }) : super(key: key);

  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  final user = FirebaseAuth.instance.currentUser;

  List users;

  String roomID;

  List emails;

  List ids;

  String frindId;

  String frindName;

  @override
  void initState() {
    users = widget.snapshot.data.documents[widget.index].data()["users"] as List;
    roomID = widget.snapshot.data.documents[widget.index].data()["chatroomid"] as String;
    emails = widget.snapshot.data.documents[widget.index].data()['emails'] as List;
    ids = widget.snapshot.data.documents[widget.index].data()['ids'] as List;
    frindId = ids[0] as String != user.uid ? ids[0] as String : ids[1] as String;
    frindName = users[0] as String != user.displayName ? users[0] as String : users[1] as String;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(frindId)
          .snapshots()
          .map(UserServices().userData),
      builder: (context, firindDataSnapshot) {
        bool showBadge;
        if (user.displayName == widget.snapshot.data.documents[widget.index].data()['lastSender']) {
          showBadge = true;
        } else {
          showBadge = widget.snapshot.data.documents[widget.index].data()["isRead"] as bool;
        }
        return firindDataSnapshot.hasData
            ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Messages(
                        group: false,
                        chatRoomId: roomID,
                        imageUrl: firindDataSnapshot.data.photoUrl,
                        userId: frindId,
                        lastSender: widget.snapshot.data.documents[widget.index]
                            .data()["lastSender"] as String,
                        username: frindName,
                        read: widget.snapshot.data.documents[widget.index].data()['isRead'] as bool,
                        lastmassage: widget.snapshot.data.documents[widget.index]
                            .data()["lastMessage"] as String,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6.0, right: 20.0),
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: constants.darkBlue,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: firindDataSnapshot.data.photoUrl == null
                            ? const AssetImage('assets/images/person.png') as ImageProvider
                            : NetworkImage(firindDataSnapshot.data.photoUrl),
                        radius: 28.0,
                      ),
                      const SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Badge(
                            badgeContent: const Icon(
                              Icons.email_outlined,
                              color: Colors.yellow,
                            ),
                            alignment: Alignment.centerLeft,
                            position: BadgePosition.topEnd(end: -44.0),
                            badgeColor: constants.lightBlue,
                            showBadge: !showBadge,
                            child: Text(
                              frindName,
                              style: TextStyle(
                                color: Colors.grey.shade200,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Text(
                              widget.snapshot.data.documents[widget.index].data()["lastMessage"] ==
                                      null
                                  ? ""
                                  : widget.snapshot.data.documents[widget.index]
                                              .data()["lastSender"] ==
                                          user.displayName
                                      ? 'You: ${widget.snapshot.data.documents[widget.index].data()["lastMessage"]}'
                                      : '${widget.snapshot.data.documents[widget.index].data()["lastMessage"]}',
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.blueGrey.shade200,
                                fontSize: 14.0,
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
                          widget.snapshot.data.documents[widget.index].data()["lastTime"] as int,
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
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}

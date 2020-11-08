import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/functions.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
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
    Constants.myName = await HelperFunction.getUsername();
    Constants.myEmail = await HelperFunction.getUserEmail();
    Constants.myEmail = Constants.myEmail.toLowerCase();
    Constants.myId = await HelperFunction.getUserId();
    databaseMethods.getChatRooms(email: Constants.myEmail).then((val) {
      setState(() {
        chatRoomStream = val;
      });
      print("welcome  ${Constants.myName} ${Constants.myEmail}");
    });
    isLoadingOver = true;

    setState(() {});
  }

  Widget contactsList(snapshot) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: snapshot.data.documents.length,
      itemBuilder: (context, index) {
        List<String> list = List.from(snapshot.data.documents[index].data()["users"]);
        String roomID = snapshot.data.documents[index].data()["chatroomid"];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Messages(
                  group: false,
                  chatRoomId: roomID,
                  lastSender: snapshot.data.documents[index].data()["lastSender"],
                  username: list[1] == Constants.myName ? list[0] : list[1],
                ),
              ),
            );
          },
          child: Container(
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
              color: snapshot.data.documents[index].data()["lastSender"] != Constants.myName
                  ? !snapshot.data.documents[index].data()["isRead"]
                      ? Constants.midBlue
                      : Constants.darkBlue
                  : Constants.darkBlue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  20,
                ),
                bottomRight: Radius.circular(
                  20,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage:

                          ///TODO: change TO URL Image, use @[SenderURL]
                          AssetImage('assets/images/person.png'),
                      radius: 35.0,
                    ),
                    SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          list[1] != user.uid ? list[0] : list[1],
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
                                : snapshot.data.documents[index].data()["lastMessage"],
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
                  ],
                ),
                SizedBox(width: 10.0),
                Column(
                  children: <Widget>[
                    Text(
                      Functions.readTimestamp(
                        snapshot.data.documents[index].data()["lastTime"] == null
                            ? 0
                            : snapshot.data.documents[index].data()["lastTime"],
                      ),
                      style: TextStyle(
                        color: Colors.grey.shade100,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Container(
                      child: snapshot.data.documents[index].data()["isRead"] == null
                          ? false
                          : snapshot.data.documents[index].data()["lastSender"] != Constants.myName
                              ? !snapshot.data.documents[index].data()["isRead"]
                                  ? Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        //   color: Constants.yellow,
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                      ),
                                      child: Text(
                                        "NEW",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Container()
                              : Container(),
                    ),
                  ],
                )
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
              print("lentgh ${snapshot.hasData}");
              return snapshot.hasData
                  ? contactsList(snapshot)
                  : Center(
                      child: Center(
                        child: emptyView(),
                      ),
                    );
              break;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        //   color: Constants.midBlue,
        child: Container(
          decoration: BoxDecoration(
            //   color: Constants.darkBlue,
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
        ),
      ),
    );
  }
}

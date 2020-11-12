import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Screens/chat/messages/messages.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String _myName, _myEmail;
String _userEmail;

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController etcSearch = new TextEditingController();
  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTitle(
                fistName: searchSnapshot.docs[index].data()["firstName"],
                lastName: searchSnapshot.docs[index].data()["lastName"],
                userEmail: searchSnapshot.docs[index].data()["email"],
                userId: searchSnapshot.docs[index].data()["teamId"],
                imgUrl: searchSnapshot.docs[index].data()["photoUrl"],
              );
            },
          )
        : Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Wait for the result here :)",
              style: TextStyle(color: Colors.grey.shade200),
            ),
          );
  }

  initiateSearch() {
    databaseMethods.getUsersByUserEmail(etcSearch.text.trim()).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
    setState(() {
      _userEmail = etcSearch.text.toLowerCase();
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    _myName = await HelperFunction.getUsername();
    _myEmail = await HelperFunction.getUserEmail();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                /*  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));*/
                Navigator.pop(context);
              },
            ),
          ],
        ),
        title: Text("Search"),
      ),
      body: Container(
        //  color: Constants.darkBlue,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: TextField(
                      controller: etcSearch,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      initiateSearch();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: CircleAvatar(
                        //   backgroundColor: Constants.darkBlue,
                        child: Icon(
                      Icons.search,
                      color: Colors.white,
                    )),
                  ),
                ),
              ],
            ),
            Expanded(child: searchList()),
          ],
        ),
      ),
    );
  }
}

class SearchTitle extends StatelessWidget {
  final String fistName, lastName, userEmail, userId, imgUrl;

  SearchTitle(
      {this.fistName, this.lastName, this.userEmail, this.userId, this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //   color: Constants.lightBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  '$fistName $lastName',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                child: Text(
                  userEmail,
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(
                  context: context,
                  userID: userEmail.trim(),
                  imgUrl: imgUrl,
                  userName: '$fistName $lastName');
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.black),
              ),
              decoration: BoxDecoration(
                color: Constants.yellow,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          )
        ],
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.length > b.length)
    return "$b\_$a";
  else
    return "$a\_$b";
}

createChatRoomAndStartConversation(
    {String userID, String userName, BuildContext context, String imgUrl}) {
  if (_userEmail != Constants.myEmail) {
    String chatRoomId = getChatRoomId(_userEmail, _myEmail);

    DatabaseMethods().getChatRooByRoomId(roomId: chatRoomId).then((value) {
      QuerySnapshot roomSnapShoot = value;

      if (roomSnapShoot.docs.isEmpty) {
        print('creating a room');
        User user = FirebaseAuth.instance.currentUser;
        List<String> users = [userName, user.displayName];
        List<String> emails = [userID.toLowerCase(), user.email.toLowerCase()];

        Map<String, dynamic> chatRoomMap = {
          "users": users,
          "emails": emails,
          "lastMessage": "",
          "isRead": false,
          "lastTime": null,
          "chatroomid": chatRoomId,
        };
        DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap).then((val) {
          print('room created');
          navigateToMessagesScreen(
              context: context,
              roomId: chatRoomId,
              imgUrl: imgUrl,
              name: userName,
              roomSnapShoot: roomSnapShoot);
        });
      } else {
        print("the room exists");
        navigateToMessagesScreen(
            context: context,
            roomId: chatRoomId,
            imgUrl: imgUrl,
            name: userName,
            roomSnapShoot: roomSnapShoot);
      }
    });
  } else {
    Fluttertoast.showToast(
        msg: "You can't text yourself :(\n يامتوحد",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.yellow,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}

navigateToMessagesScreen(
    {BuildContext context,
    String roomId,
    String imgUrl,
    String name,
    QuerySnapshot roomSnapShoot}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Messages(
        group: false,
        chatRoomId: roomId,
        imageUrl: imgUrl,
        lastSender: roomSnapShoot.docs.isEmpty
            ? null
            : roomSnapShoot.docs[0].data()['lastSender'],
        username: name,
      ),
    ),
  );
}

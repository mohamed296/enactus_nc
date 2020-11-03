import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Screens/views/chat_screen.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                username: searchSnapshot.docs[index].data()["name"],
                userEmail: searchSnapshot.docs[index].data()["email"],
                userId: searchSnapshot.docs[index].data()["teamId"],
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
        //   backgroundColor: Constants.darkBlue,
        elevation: 0.0,
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
  final String username, userEmail, userId;

  SearchTitle({this.username, this.userEmail, this.userId});

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
                  username,
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
                  context: context, userID: userEmail.trim(), userName: username);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text("Message"),
              decoration: BoxDecoration(
                //     color: Constants.yellow,
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
  if (a.substring(0, 1).codeUnitAt(0) < b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

createChatRoomAndStartConversation({String userID, String userName, BuildContext context}) {
  if (_userEmail != Constants.myEmail) {
    String chatRoomId = getChatRoomId(_userEmail, _myEmail);
    List<String> users = [userName, _myName];
    List<String> emails = [userID.toLowerCase(), _myEmail.toLowerCase()];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "emails": emails,
      "lastMessage": "",
      "isRead": false,
      "lastTime": null,
      "chatroomid": chatRoomId,
    };
    DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          username: userName,
          chatRoomId: chatRoomId,
        ),
      ),
    );
  }
}

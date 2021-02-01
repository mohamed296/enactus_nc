import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Screens/chat/messages/messages.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:enactusnca/wrapper.dart';
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
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController etcSearch = TextEditingController();
  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTitle(
                fistName: searchSnapshot.docs[index].data()["firstName"] as String,
                lastName: searchSnapshot.docs[index].data()["lastName"] as String,
                userEmail: searchSnapshot.docs[index].data()["email"] as String,
                userId: searchSnapshot.docs[index].data()["uid"] as String,
                imgUrl: searchSnapshot.docs[index].data()["photoUrl"] as String,
              );
            },
          )
        : Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Wait for the result here :)",
              style: TextStyle(color: Colors.grey.shade200),
            ),
          );
  }

  void initiateSearch() {
    databaseMethods.getUsersByUserEmail(etcSearch.text.trim()).then((val) {
      setState(() => searchSnapshot = val);
    });
    setState(() => _userEmail = etcSearch.text.toLowerCase());
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
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
              icon: const Icon(Icons.arrow_back, color: kSacandColor),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Wrapper()),
              ),
            ),
          ],
        ),
        title: const Text("Search", style: TextStyle(color: kSacandColor)),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kSacandColor, width: 3.0)),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: TextField(
                    controller: etcSearch,
                    style: const TextStyle(color: kSacandColor),
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
                  padding: const EdgeInsets.all(12),
                  child: const CircleAvatar(child: Icon(Icons.search, color: kSacandColor)),
                ),
              ),
            ],
          ),
          Expanded(child: searchList()),
        ],
      ),
    );
  }
}

class SearchTitle extends StatelessWidget {
  final String fistName, lastName, userEmail, userId, imgUrl;

  const SearchTitle({
    Key key,
    this.imgUrl,
    this.fistName,
    this.lastName,
    this.userEmail,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$fistName $lastName',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(
                context: context,
                userEmail: userEmail.trim(),
                imgUrl: imgUrl,
                userName: '$fistName $lastName',
                userId: userId,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Constants.yellow,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                "Message",
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}

String getChatRoomId(String a, String b) {
  if (a.length > b.length) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

void createChatRoomAndStartConversation({
  String userEmail,
  String userName,
  BuildContext context,
  String imgUrl,
  String userId,
}) {
  if (_userEmail != Constants.myEmail) {
    final String chatRoomId = getChatRoomId(_userEmail, _myEmail);

    DatabaseMethods().getChatRooByRoomId(roomId: chatRoomId).then(
      (value) {
        final QuerySnapshot roomSnapShoot = value;

        if (roomSnapShoot.docs.isEmpty) {
          final User user = FirebaseAuth.instance.currentUser;
          final List<String> users = [userName, user.displayName];
          final List<String> ids = [userId, user.uid];
          final List<String> emails = [userEmail.toLowerCase(), user.email.toLowerCase()];

          final Map<String, dynamic> chatRoomMap = {
            "users": users,
            "emails": emails,
            'ids': ids,
            "lastMessage": "",
            "isRead": false,
            "lastTime": null,
            "chatroomid": chatRoomId,
          };
          DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap).then((val) {
            navigateToMessagesScreen(
              context: context,
              roomId: chatRoomId,
              imgUrl: imgUrl,
              name: userName,
              userId: userId,
              roomSnapShoot: roomSnapShoot,
            );
          });
        } else {
          navigateToMessagesScreen(
            context: context,
            roomId: chatRoomId,
            imgUrl: imgUrl,
            name: userName,
            userId: userId,
            roomSnapShoot: roomSnapShoot,
          );
        }
      },
    );
  } else {
    Fluttertoast.showToast(
      msg: "You can't text yourself :(\n يامتوحد",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.yellow,
      textColor: Colors.black,
    );
  }
}

void navigateToMessagesScreen({
  BuildContext context,
  String roomId,
  String imgUrl,
  String name,
  String userId,
  QuerySnapshot roomSnapShoot,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Messages(
        group: false,
        chatRoomId: roomId,
        imageUrl: imgUrl,
        userId: userId,
        lastSender: roomSnapShoot.docs.isEmpty
            ? null
            : roomSnapShoot.docs[0].data()['lastSender'] as String,
        username: name,
      ),
    ),
  );
}

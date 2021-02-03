import 'package:enactusnca/screen/chat/recent_chat/chat_tile.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecentChat extends StatefulWidget {
  @override
  _RecentChatState createState() => _RecentChatState();
}

class _RecentChatState extends State<RecentChat> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream chatRoomStream;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    databaseMethods.getChatRooms(email: user.email).then((val) {
      setState(() => chatRoomStream = val);
    });
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data.documents.length as int,
                itemBuilder: (context, index) {
                  return ChatTile(snapshot: snapshot, index: index);
                },
              )
            : emptyView();
      },
    );
  }
}

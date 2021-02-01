import 'package:enactusnca/Screens/search/search.dart';
import 'package:enactusnca/Screens/views/search.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'groups/group_chat.dart';
// ignore: library_prefixes
import 'members/members.dart' as contactsScreen;
import 'messages/recent_chats.dart';

class Chat extends StatefulWidget {
  static String id = 'chat';

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with SingleTickerProviderStateMixin {
  TabController controller;
  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: TabBar(
              controller: controller,
              tabs: const <Widget>[
                Tab(text: 'Messages'),
                Tab(text: 'Groups'),
                Tab(text: 'Members'),
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
              ),
            ],
            centerTitle: false,
            title: const Text(
              "Chat",
              style: TextStyle(
                color: kSacandColor,
                fontSize: 25,
              ),
            ),
          ),
          body: TabBarView(
            controller: controller,
            children: [
              RecentChat(),
              GroupChat(),
              contactsScreen.Members(),
            ],
          ),
        ),
      ),
    ]);
  }
}

import 'package:enactusnca/Screens/views/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'contact_screen.dart' as contactsScreen;
import 'groups_screen.dart' as groupsScreen;
import 'recent_screen.dart' as recentScreen;

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
            bottom: TabBar(
              controller: controller,
              tabs: <Widget>[
                Tab(text: 'Messages'),
                Tab(text: 'Groups'),
                Tab(text: 'Members'),
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
              ),
            ],
            title: Text(
              "Chat",
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            elevation: 0.0,
          ),
          body: TabBarView(
            controller: controller,
            children: [
              recentScreen.RecentScreen(),
              groupsScreen.GroupsScreen(),
              contactsScreen.ContactsScreen(),
            ],
          ),
        ),
      ),
    ]);
  }
}

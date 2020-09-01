import 'package:enactusnca/Screens/views/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'contact_screen.dart' as contactsScreen;
import 'groups_screen.dart' as groupsScreen;
import 'recent_screen.dart' as recentScreen;

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new TabController(vsync: this, length: 3);
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
          //  backgroundColor: Constants.darkBlue /*Theme.of(context).primaryColor*/,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: TabBar(controller: controller, tabs: <Widget>[
              Tab(
                icon: Icon(Icons.person_add),
                text: 'Message',
              ),
              Tab(
                icon: Icon(Icons.group_add),
                text: 'Group',
              ),
              Tab(
                icon: Icon(Icons.contacts),
                text: 'Member',
              ),
            ]),
            // backgroundColor: Constants.darkBlue,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  //  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                },
              ),
              /*   IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onPressed: () {
                  authMethods.signOut();
                  HelperFunction.setUserLoggedIn(false);
                  HelperFunction.setUsername("");
                  HelperFunction.setUserEmail("");
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignIn()));
                },
              ),*/
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

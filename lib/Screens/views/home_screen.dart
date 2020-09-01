import 'package:enactusnca/Screens/views/search.dart';
import 'package:enactusnca/Screens/views/sign_in.dart';
import 'package:enactusnca/Widgets/favorite_contacts.dart';
import 'package:enactusnca/Widgets/recent_chats.dart';
import 'package:enactusnca/halper/constants.dart';
import 'package:enactusnca/halper/helperfunction.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Auth authMethods = new Auth();
  Stream chatRoomStream;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    Constants.myEmail = await HelperFunction.getUserEmail();
    Constants.myId = await HelperFunction.getUserId();
    Constants.myName = await HelperFunction.getUsername();
    setState(() {
      isLoading = false;
    });
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
            bottom: TabBar(tabs: <Widget>[
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
          body: isLoading
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //  CategorySelector(),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              topLeft: Radius.circular(30)),
                          //   color: Constants.darkBlue,
                        ),
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              child: FavoriteContacts(),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30)),
                            ),
                            RecentChat(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    ]);
  }
}

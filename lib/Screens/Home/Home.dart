import 'package:enactusnca/Screens/AddNewPost/add_new_post.dart';
import 'package:enactusnca/Screens/Events/Calendar.dart';
import 'package:enactusnca/Screens/Home/PostsList.dart';
import 'package:enactusnca/Screens/Profile/HelpSupport.dart';
import 'package:enactusnca/Screens/Settings/Settings.dart';
import 'package:enactusnca/Screens/authentication/sign_in.dart';
import 'package:enactusnca/Widgets/PopUpMenu.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  static String id = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController scrollController = ScrollController();
  final user = FirebaseAuth.instance.currentUser;
  ScrollController controller = ScrollController();
  String name, email;
  String firstName, lastName;
  Auth authMethods = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          // backgroundColor: KMainColor,
          child: Icon(
            Icons.add,
            // color: KSacandColor,
          ),
          onPressed: () => Navigator.pushNamed(context, AddNewPost.id)),
      /* appBar: AppBar(
        elevation: 0.0,
        title: Text('Discovery'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: select,
            itemBuilder: (context) {
              return PopUpMenu.choices.map((String choice) {
                return PopupMenuItem(
                  child: Text(choice),
                  value: choice,
                );
              }).toList();
            },
          ),
        ],
      ),*/
      appBar: AppBar(
        leading: Center(
          child: Container(
            /*  decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                scale: 10.0,
                fit: BoxFit.fill,
                image: AssetImage('assets/images/logo.png'),
              ),
            ), */

            padding: EdgeInsets.only(left: 5),
            height: 100,
            child: Center(
              child: Image(
                image: AssetImage(
                  'assets/images/logo.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          Hero(
            tag: 'Icon1',
            child: new IconButton(
                icon: Icon(
                  FontAwesomeIcons.calendar,
                  color: Color.fromRGBO(253, 194, 35, 1.0),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Calender.id);
                }),
          ),

          /*  Hero(
            tag: 'Icon3',
            child: new IconButton(
                icon: Icon(
                  FontAwesomeIcons.edit,
                  color: Color.fromRGBO(253, 194, 35, 1.0),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, EditPost.id);
                }),
          ),*/
          PopupMenuButton(
            onSelected: select,
            itemBuilder: (context) {
              return PopUpMenu.choices.map((String choice) {
                return PopupMenuItem(
                  child: Text(choice),
                  value: choice,
                );
              }).toList();
            },
          ),
        ],

        // title: Text('Home',),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/back.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: PostsList(),
      ),
    );
  }

  void select(String choice) {
    if (choice == PopUpMenu.aboutUS) {
      Navigator.pushNamed(context, HelpSupport.id);
      //  auth.signOutGoogle(context);
    } else if (choice == PopUpMenu.signOut) {
      authMethods.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    }
  }
}

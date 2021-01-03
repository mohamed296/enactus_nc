import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/Screens/AddNewPost/add_new_post.dart';
import 'package:enactusnca/Screens/Events/events.dart';
import 'package:enactusnca/Screens/Home/PostsList.dart';
import 'package:enactusnca/Screens/Profile/HelpSupport.dart';
import 'package:enactusnca/Screens/authentication/sign_in.dart';
import 'package:enactusnca/Widgets/PopUpMenu.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:enactusnca/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
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
    return FutureBuilder<UserModel>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get()
            .then(UserServices().userData),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    Image.asset(
                      'assets/images/back.jpg',
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Scaffold(
                      backgroundColor: Colors.transparent,
                      floatingActionButton: snapshot.data.isAdmin || snapshot.data.isHead
                          ? FloatingActionButton(
                              child: Icon(Icons.add),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddNewPost()),
                              ),
                            )
                          : Container(),
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        leading: Center(
                          child: Container(
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
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Events()),
                              ),
                            ),
                          ),
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
                      ),
                      body: PostsList(),
                    ),
                  ],
                );
        });
  }

  void select(String choice) {
    if (choice == PopUpMenu.aboutUS) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HelpSupport()),
      );
      //  auth.signOutGoogle(context);
    } else if (choice == PopUpMenu.signOut) {
      authMethods.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    }
  }
}

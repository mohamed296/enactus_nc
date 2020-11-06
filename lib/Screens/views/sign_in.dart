import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Screens/views/sign_up.dart';
import 'package:enactusnca/Widgets/edite_text.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../wrapper.dart';

class SignIn extends StatefulWidget {
  static String id = 'SignIn';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  DatabaseMethods _databaseMethods = new DatabaseMethods();
  Auth _auth = new Auth();
  TextEditingController tecEmail = new TextEditingController();
  TextEditingController tecPassword = new TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapshot;
  bool isSignIn = Constants.isSignIn;

  signIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    HelperFunction.setUserEmail(tecEmail.text);
    _databaseMethods.getUsersByUserEmail(tecEmail.text).then((val) {
      snapshot = val;
      /**
       * sometimes @val is null no clue why this is causing the double chat
       * issue,
       * */
      String name =
          '${snapshot.docs[0].data()["firstName"]} ${snapshot.docs[0].data()["lastName"]}';
      HelperFunction.setUsername(name.toLowerCase().toString());
      HelperFunction.setUserLoggedIn(true);
    });
    setState(() {
      isLoading = true;
    });
    _auth
        .signInWithEmail(
            email: tecEmail.text.trim(), password: tecPassword.text.trim())
        .then((value) {
      if (value != null) {
        sharedPreferences.setString('user', tecEmail.text);
        Navigator.of(context).pushNamed(Wrapper.id);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Constants.darkBlue,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            //   color: Constants.midBlue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      fontSize: 28.0,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              EditeText(
                textEditingController: tecEmail,
                title: "Email",
                obscureText: false,
              ),
              EditeText(
                textEditingController: tecPassword,
                title: "Password",
                obscureText: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10.0),
                          margin: EdgeInsets.only(
                              top: 5.0, left: 35.0, bottom: 5.0),
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSignIn = !isSignIn;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 14.0,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 30.0),
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      //   backgroundColor: Constants.yellow,
                      radius: 35.0,
                      child: IconButton(
                        onPressed: () {
                          signIn();
                        },
                        icon: Icon(
                          Icons.arrow_forward,
                          //    color: Constants.darkBlue,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

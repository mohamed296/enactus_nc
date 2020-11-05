import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/functions.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Screens/views/sign_in.dart';
import 'package:enactusnca/Widgets/edite_text.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../wrapper.dart';

import '../../Helpers/helperfunction.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  DatabaseMethods _databaseMethods = new DatabaseMethods();
  Auth _auth = new Auth();
  TextEditingController tecName = new TextEditingController();
  TextEditingController tecUserName = new TextEditingController();
  TextEditingController tecSignUpCode = new TextEditingController();
  TextEditingController tecEmailUp = new TextEditingController();
  TextEditingController tecPasswordUp = new TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapshot;
  bool isSignIn = Constants.isSignIn;
  Map<String, dynamic> userInfo;

  @override
  void initState() {
    super.initState();
    _auth.signOut();
  }

  signUp() {
    HelperFunction.setUserEmail(tecEmailUp.text.toLowerCase().toString());
    HelperFunction.setUsername(tecName.text.toLowerCase().toString());
    userInfo = {
      "name": tecName.text,
      "userName": tecUserName.text.toLowerCase(),
      "email": tecEmailUp.text.toLowerCase(),
      "teamId": tecSignUpCode.text.toLowerCase(),
      "password": tecPasswordUp.text,
      "photoURL": '',
      "isAdmin": Functions.checkId(tecSignUpCode.toString().toLowerCase()),
      "joiningDate": DateTime.now(),
    };

    setState(() {
      isLoading = !isLoading;
    });
    //TODO: check if sign up operation has been executed correctly
    Auth()
        .signUpWithEmail(
            email: tecEmailUp.text.trim().toLowerCase(),
            password: tecPasswordUp.text,
            name: tecName.text,
            imgUrl: null)
        .then((value) {
      setState(() {});
      _databaseMethods.uploadUserInfo(
          userMap: userInfo, uid: FirebaseAuth.instance.currentUser.uid);
      HelperFunction.setUserLoggedIn(true);
      Navigator.of(context).popAndPushNamed(Wrapper.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Constants.darkBlue,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            //  color: Constants.midBlue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
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
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 28.0,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    EditeText(
                      textEditingController: tecName,
                      title: "Full name",
                      obscureText: false,
                    ),
                    EditeText(
                      textEditingController: tecUserName,
                      title: "Full name",
                      obscureText: false,
                    ),
                    EditeText(
                      textEditingController: tecSignUpCode,
                      title: "Team Id",
                      obscureText: false,
                    ),
                    EditeText(
                      textEditingController: tecEmailUp,
                      title: "E-mail",
                      obscureText: false,
                    ),
                    EditeText(
                      textEditingController: tecPasswordUp,
                      title: "Password",
                      obscureText: true,
                    ),

                    /**TODO: add spinner with the existing communities and and departments **/
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                        isSignIn = !isSignIn;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      margin: EdgeInsets.only(top: 5, left: 50, bottom: 5),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 14.0,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 30.0),
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      //  backgroundColor: Constants.yellow,
                      radius: 35.0,
                      child: IconButton(
                        onPressed: () {
                          signUp();
                        },
                        icon: Icon(
                          Icons.arrow_forward,
                          //     color: Constants.darkBlue,
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Wrapper()));
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
      backgroundColor: Constants.darkBlue,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Center(
                child: Image(
                  width: 200,
                  image: AssetImage('assets/images/team_logo.png'),
                ),
              ),
            ),
            Column(
              children: [
                RaisedButton(
                  onPressed: singInWithPhoneNumber(),
                  textColor: Colors.black,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFFFFB300),
                          Color(0xFFFFA000),
                          Color(0xFFFF8F00),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 15),
                    child: const Text('SIGN IN WITH PHONE',
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                  ),
                ),
                SizedBox(height: 10),
                RaisedButton(
                  onPressed: signInWithGoogle(),
                  textColor: Colors.black,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFFFFB300),
                          Color(0xFFFFA000),
                          Color(0xFFFF8F00),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: const Text('SIGN IN WITH GOOGLE',
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  singInWithPhoneNumber() {}

  signInWithGoogle() {}
}

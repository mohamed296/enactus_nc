import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Screens/authentication/forgot_password.dart';
import 'package:enactusnca/Screens/authentication/sign_up.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/Widgets/custom_dialog.dart';
import 'package:enactusnca/Widgets/edite_text.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../wrapper.dart';

class SignIn extends StatefulWidget {
  static String id = 'SignIn';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final DatabaseMethods _databaseMethods = DatabaseMethods();
  final Auth _auth = Auth();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPassword = TextEditingController();
  QuerySnapshot snapshot;
  bool isSignIn = Constants.isSignIn;
  ProgressDialog progressDialog;

  Future signIn() async {
    progressDialog.show();
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    HelperFunction.setUserEmail(tecEmail.text);
    _databaseMethods.getUsersByUserEmail(tecEmail.text).then((val) {
      snapshot = val;
      final String name =
          '${snapshot.docs[0].data()["firstName"]} ${snapshot.docs[0].data()["lastName"]}';
      HelperFunction.setUsername(name.toLowerCase().toString());
      HelperFunction.setUserLoggedIn(true);
    });
    _auth
        .signInWithEmail(
            email: tecEmail.text.trim(), password: tecPassword.text.trim())
        .then(
      (value) {
        if (value == 'Active') {
          sharedPreferences.setString('user', tecEmail.text);
          progressDialog.hide();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Wrapper()));
        } else {
          progressDialog.hide();
          showDialog(
            context: context,
            barrierDismissible: false,
            useRootNavigator: true,
            useSafeArea: true,
            builder: (context) => CustomDialog(
              showTitle: false,
              title: '',
              content: value,
              onTap: () => Navigator.pop(context),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    tecEmail.dispose();
    tecPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context, showLogs: true);
    progressDialog.style(message: 'loading...');
    return Stack(
      children: [
        Image.asset(
          'assets/images/back.jpg',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/back.jpg'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                width: 200,
                                child: const Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/logo.png',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                child: const Center(
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        letterSpacing: 1.2,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              EditeText(
                                textEditingController: tecEmail,
                                title: "Email",
                                obscureText: false,
                              ),
                              const SizedBox(height: 15),
                              EditeText(
                                textEditingController: tecPassword,
                                title: "Password",
                                obscureText: true,
                              ),
                              const SizedBox(height: 15),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0,
                                            vertical: 10.0,
                                          ),
                                          margin: const EdgeInsets.only(
                                            top: 5.0,
                                            left: 35.0,
                                            bottom: 5.0,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ForgotPassword(),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              "Forgot password?",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isSignIn = !isSignIn;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUp()),
                                            );
                                          });
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 10.0),
                                          margin: const EdgeInsets.only(
                                              top: 5.0, bottom: 5.0),
                                          child: const Text(
                                            "Sign up",
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 14.0,
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 30.0),
                                    alignment: Alignment.topRight,
                                    child: CircleAvatar(
                                      backgroundColor: kSacandColor,
                                      radius: 35.0,
                                      child: IconButton(
                                        onPressed: () {
                                          signIn();
                                        },
                                        icon: const Icon(Icons.arrow_forward),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

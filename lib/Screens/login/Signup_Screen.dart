/*import 'dart:io';
import 'package:enactusnca/Screens/login/login_Screen.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/Widgets/CustomText.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignupScreen extends StatefulWidget {
  static String id = 'SignupScreen';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _auth = Auth();
  String _email;
  String _password;
  String _username;
  String _id;
  String _number;
  bool _obscureText = true;

  ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context, showLogs: true);
    progressDialog.style(message: 'loading...');

    return Scaffold(
      backgroundColor: KMainColor,
      body: Form(
        key: _globalKey,
        child: ListView(children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              Container(
                height: MediaQuery.of(context).size.height * .1,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage(
                        'assets/images/enplus.png',
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                child: Center(
                  child: SingleChildScrollView(
                    child: Card(
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        color: KSacandColor,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45.0),
                          borderSide: BorderSide.none,
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              //  height: MediaQuery.of(context).size.height,
                              child: Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Material(
                                  color: Color.fromRGBO(253, 194, 35, 1.0),
                                  // elevation: 14.0,
                                  shadowColor: Color(0x802196F3),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              // height: 200.0,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0, bottom: 20.0),
                                              child: Text(
                                                "Sign up".toUpperCase(),
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        25, 53, 93, 1.0),
                                                    fontSize: 40.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 0, 20, 0),
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              width: double.infinity,
                                              child: CustomText(
                                                hint: 'Enter your ID',
                                                icon: Icons.info,
                                                onClick: (value) {
                                                  _email = value;
                                                },
                                              ),
                                            ),
                                            /*  Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 0, 20, 0),
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              width: double.infinity,
                                              child: CustomText(
                                                hint: 'Enter your Email',
                                                icon: Icons.email,
                                                onClick: (value) {
                                                  _email = value;
                                                },
                                              ),
                                            ),*/
                                            /*   Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 0, 20, 0),
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              width: double.infinity,
                                              child: CustomText(
                                                hint: 'Enter your Number',
                                                icon:
                                                    Icons.format_list_numbered,
                                                onClick: (value) {
                                                  _email = value;
                                                },
                                              ),
                                            ),*/
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 0, 20, 0),
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              width: double.infinity,
                                              child: CustomText(
                                                hint: 'Enter your UserName',
                                                icon: Icons.person,
                                                onClick: (value) {
                                                  _email = value;
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 0, 20, 0),
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              width: double.infinity,
                                              child: CustomText(
                                                hint: 'Enter your passord',
                                                icon: Icons.person,
                                                onClick: (value) {
                                                  _password = value;
                                                },
                                              ),
                                            ),
                                            /*  Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 0, 20, 0),
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              width: double.infinity,
                                              child: TextField(
                                                
                                                obscureText: _obscureText,
                                                cursorColor: Colors.amber,
                                                textAlign: TextAlign.start,
                                                decoration: InputDecoration(
                                                  suffixIcon: IconButton(
                                                      icon: Icon(
                                                          Icons.visibility),
                                                      onPressed: () {
                                                        setState(() {
                                                          _obscureText =
                                                              !_obscureText;
                                                        });
                                                      }),
                                                  contentPadding:
                                                      const EdgeInsets.all(
                                                          10.0),
                                                  icon: Icon(Icons.lock),
                                                  hintText:
                                                      "Enter your Password",
                                                  fillColor: Colors.blue
                                                      .withOpacity(0.9),
                                                ),
                                              ),
                                            ),*/
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Hero(
                                                tag: 'button1',
                                                child: Builder(
                                                  builder: (context) =>
                                                      MaterialButton(
                                                    onPressed: () async {
                                                      if (_globalKey
                                                          .currentState
                                                          .validate()) {
                                                        _globalKey.currentState
                                                            .save();

                                                        try {
                                                          progressDialog.show();
                                                          final AuthResult =
                                                              await _auth.signUp(
                                                                  _email,
                                                                  _password);
                                                          Navigator.pushNamed(
                                                              context,
                                                              LoginScreen.id);
                                                          progressDialog.hide();
                                                        } catch (e) {
                                                          progressDialog.show();
                                                          Scaffold.of(context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content:
                                                                Text(e.message),
                                                          ));
                                                          progressDialog.hide();
                                                        }
                                                      }
                                                    },
                                                    /*    onPressed: () async {
                                                      try {
                                                        final user = await _auth
                                                            .signInWithEmailAndPassword(
                                                                email: email,
                                                                password:
                                                                    password);
                                                        if (user != null) {}
                                                      } catch (e) {
                                                        print(e);
                                                      }
                                                    },*/
                                                    color: Color.fromRGBO(
                                                        25, 53, 93, 1.0),
                                                    minWidth: 50,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 20),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Icon(
                                                      Icons.chevron_right,
                                                      size: 30,
                                                      color: Color.fromRGBO(
                                                          253, 194, 35, 1.0),
                                                    ),
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 30.0,
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              SizedBox(
                height: 60.0,
                width: 250,
                child: Hero(
                  tag: RaisedButton,
                  child: RaisedButton(
                    child: Text('Sign in'),
                    onPressed: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => new LoginScreen()));
                    },
                    color: Color.fromRGBO(253, 194, 35, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
*/

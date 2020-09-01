/*import 'package:enactusnca/Admin/Bott_admin.dart';
import 'package:enactusnca/Admin/adminhome.dart';
import 'package:enactusnca/BottomNavBar.dart';
import 'package:enactusnca/Screens/login/Signup_Screen.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/Widgets/CustomText.dart';
import 'package:enactusnca/provider/Admin.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  var _contraller = ScrollController();
  final _auth = Auth();
  final adminPassword = 'EN2020';
  String _email;
  String _password;
  bool _obscureText = true;
  bool isAdmin = false;
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
                                  color: KSacandColor,
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
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0, bottom: 20.0),
                                              child: Text(
                                                "Sign In".toUpperCase(),
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
                                                hint: ' UserName',
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
                                                hint: 'passord',
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
                                                onChanged: (value) {
                                                  _password = value;
                                                },
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
                                                  hintText: " Password",
                                                  fillColor: Colors.blue
                                                      .withOpacity(0.9),
                                                ),
                                              ),
                                            ),*/
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: FlatButton(
                                                child: Text(
                                                  "forget password"
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        25, 53, 93, 1.0),
                                                  ),
                                                ),
                                                onPressed: () {},
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Hero(
                                                tag: 'button1',
                                                child: Builder(
                                                  builder: (context) =>
                                                      MaterialButton(
                                                    onPressed: () async {
                                                      _validate(context);
                                                    },
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
                                              height: 10.0,
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 30,
                                                            vertical: 10),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Provider.of<Admin>(
                                                                context,
                                                                listen: false)
                                                            .changeIsAdmin(
                                                                true);
                                                      },
                                                      child: Text('i\'m Admin',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Provider.of<
                                                                              Admin>(
                                                                          context)
                                                                      .isAdmin
                                                                  ? KSacandColor
                                                                  : Colors
                                                                      .white)),
                                                    )),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 30,
                                                            vertical: 10),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Provider.of<Admin>(
                                                                context,
                                                                listen: false)
                                                            .changeIsAdmin(
                                                                false);
                                                      },
                                                      child: Text('i\'m user',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Provider.of<
                                                                              Admin>(
                                                                          context)
                                                                      .isAdmin
                                                                  ? Colors.white
                                                                  : KSacandColor)),
                                                    )),
                                              ],
                                            )
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
                    child: Text('Sign up'),
                    onPressed: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => new SignupScreen()));
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

  void _validate(BuildContext context) async {
    // progressDialog.show();
    if (_globalKey.currentState.validate()) {
      _globalKey.currentState.save();
      if (Provider.of<Admin>(context, listen: false).isAdmin) {
        if (_password == adminPassword) {
          try {
            _auth.signIn(_email, _password);
            Navigator.pushNamed(context, BottAdmin.id);
          } catch (e) {
            //  progressDialog.hide();
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(e.message)));
          }
        } else {
          // progressDialog.hide();
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('pass is wrong')));
        }
      } else {
        try {
          await _auth.signIn(_email, _password);
          Navigator.pushNamed(context, BottomNavBar.id);
        } catch (e) {
          //  progressDialog.hide();
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
        }
      }
      progressDialog.hide();
    }
  }
}
*/

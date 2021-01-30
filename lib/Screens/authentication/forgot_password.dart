import 'package:email_validator/email_validator.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> form;
  String email;
  bool loading;
  @override
  void initState() {
    super.initState();
    form = GlobalKey<FormState>();
    loading = false;
  }

  void resetPassword() async {
    if (form.currentState.validate()) {
      try {
        setState(() {
          loading = true;
        });
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Email has been sent.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green[900],
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red[900],
          ),
        );
      }
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    width: 200,
                                    child: Center(
                                      child: Image(
                                        image: AssetImage(
                                          'assets/images/logo.png',
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 20),
                                    child: Center(
                                      child: Text(
                                        "Forgot Password",
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Form(
                                    key: form,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          validator: (value) {
                                            setState(() {
                                              email = value;
                                            });

                                            if (EmailValidator.validate(
                                                value)) {
                                              return null;
                                            }
                                            return 'Email validator';
                                          },
                                          style: TextStyle(color: Colors.white),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            errorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                            errorStyle: TextStyle(
                                                color: Colors.redAccent),
                                            hintText: 'example@abc.com',
                                            labelText: 'Email',
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            hintStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  (loading)
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          height: 50,
                                          child: RaisedButton(
                                            shape: StadiumBorder(),
                                            color: Colors.amber[700],
                                            child: Text(
                                              'Reset Password',
                                              key: UniqueKey(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              resetPassword();
                                            },
                                          ),
                                        ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: FlatButton(
                                      padding: EdgeInsets.zero,
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

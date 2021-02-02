import 'package:email_validator/email_validator.dart';
import 'package:enactusnca/components/custom_dialog.dart';
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

  Future resetPassword() async {
    if (form.currentState.validate()) {
      try {
        setState(() {
          loading = true;
        });
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            showTitle: true,
            title: 'Attention..',
            content: 'Email has been sent.',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        );
      } catch (error) {
        showDialog(
          context: context,
          barrierDismissible: false,
          useRootNavigator: true,
          useSafeArea: true,
          builder: (context) => CustomDialog(
            showTitle: true,
            title: 'Attentionزز',
            content: error.toString(),
            onTap: () {
              Navigator.pop(context);
            },
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
                                //   color: Constants.midBlue,
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
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    padding: const EdgeInsets.symmetric(vertical: 20),
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
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                    child: const Center(
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

                                            if (EmailValidator.validate(value)) {
                                              return null;
                                            }
                                            return 'Email validator';
                                          },
                                          style: const TextStyle(color: Colors.white),
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: const InputDecoration(
                                            errorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                            errorStyle: TextStyle(color: Colors.redAccent),
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
                                              borderSide: BorderSide(color: Colors.white),
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  if (loading)
                                    const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  else
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      height: 50,
                                      child: RaisedButton(
                                        shape: const StadiumBorder(),
                                        color: Colors.amber[700],
                                        onPressed: () {
                                          resetPassword();
                                        },
                                        child: Text(
                                          'Reset Password',
                                          key: UniqueKey(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Align(
                                    child: FlatButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.white, fontSize: 18),
                                      ),
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

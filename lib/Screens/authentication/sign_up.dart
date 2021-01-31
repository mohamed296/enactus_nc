import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/Screens/authentication/sign_in.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/Widgets/custom_dialog.dart';
import 'package:enactusnca/Widgets/edite_text.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController tecFirstName = TextEditingController();
  TextEditingController tecLastName = TextEditingController();
  TextEditingController tecEmailUp = TextEditingController();
  TextEditingController tecPasswordUp = TextEditingController();

  List<String> communities = Constants.communities;
  List<String> mmDep = Constants.mmDep;
  List<String> erDep = Constants.erDep;
  List<String> secondList = [];
  String department, community;
  QuerySnapshot snapshot;
  bool isSignIn = Constants.isSignIn;
  ProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();
    secondList.addAll(mmDep);
    department = mmDep[0];
    community = communities[0];
  }

  Future signUp() async {
    progressDialog.show();
    final UserModel userModel = UserModel(
      firstName: tecFirstName.text,
      lastName: tecLastName.text,
      email: tecEmailUp.text.toLowerCase(),
      community: community,
      department: department,
      joiningDate: Timestamp.now(),
      username: '${tecFirstName.text}${tecLastName.text}',
    );
    Auth().signUpWithEmail(userModel, tecPasswordUp.text).then((value) {
      if (value == 'success') {
        HelperFunction.setUserEmail(tecEmailUp.text.toLowerCase());
        HelperFunction.setUserEmail(tecEmailUp.text.toLowerCase());
        progressDialog.hide();
        showDialog(
          context: context,
          barrierDismissible: false,
          useRootNavigator: true,
          useSafeArea: true,
          builder: (context) => CustomDialog(
            showTitle: true,
            title: 'Pending Approval..',
            content:
                'You are successfully Signed Up, please Wait while you approved!',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignIn()),
            ),
          ),
        );
      } else {
        progressDialog.hide();
        showDialog(
          context: context,
          barrierDismissible: false,
          useRootNavigator: true,
          useSafeArea: true,
          builder: (context) => CustomDialog(
            showTitle: false,
            onTap: () => Navigator.pop(context),
            title: 'Error..',
            content: value,
          ),
        );
      }
    });
  }

  Widget dropDown({List<String> list, String dropdownValue}) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 20,
      elevation: 16,
      style: const TextStyle(color: Colors.grey),
      underline: Container(
        height: 2,
      ),
      onChanged: (String newValue) {
        setState(() {
          if (list.length >= communities.length) {
            secondList.clear();
            if (newValue == list[0]) {
              secondList.addAll(mmDep);
              if (list[0] == communities[0]) {
                community = newValue;
                department = secondList[0];
              }
            } else if (newValue == list[1]) {
              secondList.addAll(erDep);
              if (list[0] == communities[0]) {
                community = newValue;
                department = secondList[0];
              }
            } else if (newValue == list[2]) {
              secondList.add(communities[2]);
              community = newValue;
              department = null;
            } else if (newValue == list[3]) {
              secondList.add(communities[3]);
              department = null;
              community = newValue;
            } else if (newValue == list[4]) {
              secondList.add(communities[4]);
              community = newValue;
              department = null;
            }
          } else {
            department = newValue;
            dropdownValue = newValue;
          }
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 28.0,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        EditeText(
                          textEditingController: tecFirstName,
                          title: "First name",
                          obscureText: false,
                        ),
                        const SizedBox(height: 12),
                        EditeText(
                          textEditingController: tecLastName,
                          title: "Last name",
                          obscureText: false,
                        ),
                        const SizedBox(height: 12),
                        EditeText(
                          textEditingController: tecEmailUp,
                          title: "E-mail",
                          obscureText: false,
                        ),
                        const SizedBox(height: 12),
                        EditeText(
                          textEditingController: tecPasswordUp,
                          title: "Password",
                          obscureText: true,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text("Committee "),
                            dropDown(
                                list: communities, dropdownValue: community),
                          ],
                        ),
                        if (community == communities.elementAt(0) ||
                            community == communities.elementAt(1))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text("department "),
                              dropDown(
                                  list: secondList, dropdownValue: department),
                            ],
                          )
                        else
                          Container()
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => SignIn()),
                            );
                            isSignIn = !isSignIn;
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          margin: const EdgeInsets.only(
                              top: 5, left: 50, bottom: 5),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 14.0,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(20)),
                      Container(
                        margin: const EdgeInsets.only(right: 30.0),
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          backgroundColor: kSacandColor,
                          radius: 35.0,
                          child: IconButton(
                            onPressed: () => signUp(),
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
    );
  }
}

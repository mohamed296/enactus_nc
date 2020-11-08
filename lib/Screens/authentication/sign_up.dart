import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/Screens/authentication/sign_in.dart';
import 'package:enactusnca/Widgets/edite_text.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../wrapper.dart';

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
  List<String> communities = ['Multimedia', 'ER', 'HR', 'Project', 'Presentation'];
  List<String> mmDep = ['Developing', 'Social Media', 'Photography', 'Graphic Design'];
  List<String> erDep = ['FR', 'BR', 'Logistics'];
  List<String> secondList = List();
  String department, community;
  bool isLoading = false;
  QuerySnapshot snapshot;
  bool isSignIn = Constants.isSignIn;

  @override
  void initState() {
    super.initState();
    secondList.addAll(mmDep);
    department = mmDep[0];
    community = communities[0];
  }

  signUp() {
    UserModel userModel = UserModel(
      firstName: tecFirstName.text,
      lastName: tecLastName.text,
      photoUrl: '',
      email: tecEmailUp.text,
      community: community,
      department: department,
      joiningDate: Timestamp.now(),
      username: '${tecFirstName.text}${tecLastName.text}',
      isActive: false,
      isHead: false,
    );

    setState(() => isLoading = !isLoading);
    Auth().signUpWithEmail(userModel, tecPasswordUp.text).whenComplete(() {
      setState(() => isLoading = !isLoading);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Wrapper()));
    }).catchError((e) => print(e));
  }

  Widget dropDown({List<String> list, String dropdownValue}) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(
        Icons.arrow_drop_down,
      ),
      iconSize: 20,
      elevation: 16,
      style: TextStyle(color: Colors.grey),
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
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
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
                      color: Colors.white,
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
                      EditeText(
                        textEditingController: tecLastName,
                        title: "Last name",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("community "),
                          dropDown(list: communities, dropdownValue: community),
                        ],
                      ),
                      community == communities.elementAt(0) || community == communities.elementAt(1)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("department "),
                                dropDown(list: secondList, dropdownValue: department),
                              ],
                            )
                          : Container()
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
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        margin: EdgeInsets.only(top: 5, left: 50, bottom: 5),
                        child: Text(
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
                    Container(
                      margin: EdgeInsets.only(right: 30.0),
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 35.0,
                        child: IconButton(
                          onPressed: () => signUp(),
                          icon: Icon(Icons.arrow_forward),
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
    );
  }
}

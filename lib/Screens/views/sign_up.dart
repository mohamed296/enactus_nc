import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Admin/Bott_admin.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Screens/views/sign_in.dart';
import 'package:enactusnca/Widgets/edite_text.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController tecFirstName = new TextEditingController();
  TextEditingController tecLastName = new TextEditingController();
  TextEditingController tecEmailUp = new TextEditingController();
  TextEditingController tecPasswordUp = new TextEditingController();
  List<String> communities = [
    'Multimedia',
    'ER',
    'HR',
    'Project',
    'Presentation'
  ];
  List<String> mmDep = [
    'Developing',
    'Social Media',
    'Photography',
    'Graphic Design'
  ];
  List<String> erDep = ['FR', 'BR', 'Logistics'];
  List<String> secondList = new List();
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
    HelperFunction.setUserEmail(tecEmailUp.text.toLowerCase().toString());
    HelperFunction.setUsername(tecFirstName.text.toLowerCase().toString());
    Map<String, dynamic> userInfo = {
      "firstName": tecFirstName.text,
      "lastName": tecLastName.text,
      "department": department,
      "community": community,
      "email": tecEmailUp.text.toLowerCase(),
      "password": tecPasswordUp.text,
      "photoURL": '',
      "isActive": false,
      "isHead": false,
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
            name: tecFirstName.text,
            imgUrl: null)
        .then((value) {
      setState(() {});
      DatabaseMethods().uploadUserInfo(
          userMap: userInfo, uid: FirebaseAuth.instance.currentUser.uid);
      HelperFunction.setUserLoggedIn(true);
      Navigator.of(context).popAndPushNamed(BottAdmin.id);
    });
  }

  Widget DropDown({List<String> list, String dropdownValue}) {
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
              department = newValue;
            } else if (newValue == list[3]) {
              secondList.add(communities[3]);
              community = newValue;
              department = newValue;
            } else if (newValue == list[4]) {
              secondList.add(communities[4]);
              community = newValue;
              department = newValue;
            }
          } else {
            department = newValue;
            dropdownValue = newValue;
            print("called + ${secondList.length}");
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
    /**Active = Boolean Field(Default=False)*/
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
                      children: [
                        Text("Select your community "),
                        SizedBox(width: 20),
                        DropDown(list: communities, dropdownValue: community),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Select your department "),
                        SizedBox(width: 20),
                        DropDown(list: secondList, dropdownValue: department),
                      ],
                    )
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

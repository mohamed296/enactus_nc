import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilScreen extends StatefulWidget {
  static String id = 'editProfilScreen';
  final UserModel userModel;

  const EditProfilScreen({this.userModel});
  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String firstName, lastName, email, department, community;
  File _image;
  String _imgURL;
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

  @override
  void initState() {
    super.initState();

    community = widget.userModel.community;
    department = widget.userModel.department;
  }

  bool loading = false;

  Future getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _imgURL = pickedFile.hashCode.toString();
      _image = File(pickedFile.path);
    });
    return _image;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Edit Profile",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 3, color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.white.withOpacity(0.1),
                                  offset: Offset(0, 10),
                                ),
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: _image != null
                                    ? FileImage(_image)
                                    : NetworkImage(
                                        user?.photoURL ??
                                            "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png",
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(width: 2, color: Colors.white),
                                  color: Theme.of(context).accentColor,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.edit, color: Colors.white),
                                  onPressed: getImage,
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 35.0),
                      child: TextField(
                        onChanged: (String val) =>
                            setState(() => firstName = val),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: 'FirstName',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "${widget.userModel.firstName}",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 35.0),
                      child: TextField(
                        onChanged: (String val) =>
                            setState(() => lastName = val),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: 'lastName',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "${widget.userModel.lastName}",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 35.0),
                      child: TextField(
                        onChanged: (String val) => setState(() => email = val),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: 'E-mail',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "${widget.userModel.email}",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 35.0),
                      child: Row(
                        children: [
                          Text("Community : "),
                          SizedBox(
                            width: 15,
                          ),
                          DropdownButton(
                              value: community,
                              items: communities.map((e) {
                                return DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  community = value;
                                });
                              }),
                        ],
                      ),
                    ),
                    community == communities[0] || community == communities[1]
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 35.0),
                            child: Row(
                              children: [
                                Text("Departments : "),
                                SizedBox(
                                  width: 15,
                                ),
                                DropdownButton(
                                    value: department,
                                    items: mmDep.map((e) {
                                      return DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        community == communities[0] ||
                                                community == communities[1]
                                            ? department = value
                                            : department = null;
                                      });
                                    }),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlineButton(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "CANCEL",
                            style: TextStyle(fontSize: 15, letterSpacing: 2.2),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Builder(
                          builder: (context) => RaisedButton(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Theme.of(context).accentColor,
                            child: Text(
                              "SAVE",
                              style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 2.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              setState(() => loading = true);
                              uploadImage(context).then((value) {
                                FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(user.uid)
                                    .update({
                                  "fistName":
                                      firstName ?? widget.userModel.firstName,
                                  "lastName":
                                      lastName ?? widget.userModel.lastName,
                                  "email": email ?? widget.userModel.email,
                                  "community":
                                      community ?? widget.userModel.community,
                                  "department":
                                      department ?? widget.userModel.department,
                                  "photoURL":
                                      _imgURL ?? widget.userModel.photoUrl,
                                });
                                user.updateProfile(
                                    displayName: widget.userModel.username,
                                    photoURL: _imgURL);
                              }).whenComplete(() {
                                setState(() => loading = false);
                                Navigator.pop(context);
                              }).catchError((e) => print(e));
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        loading == true
            ? Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(child: CircularProgressIndicator()),
              )
            : Container(),
      ],
    );
  }

  Future uploadImage(BuildContext context) async {
    try {
      StorageReference ref = FirebaseStorage.instance.ref().child(_imgURL);
      StorageUploadTask storageUploadTask = ref.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(content: Text("Success")),
      // );
      String url = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        _imgURL = url;
      });
      return url;
    } catch (ex) {
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(ex.message),
      //   ),
      // );
    }
  }
}

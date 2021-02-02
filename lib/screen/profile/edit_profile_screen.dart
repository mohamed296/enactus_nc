import 'dart:io';
import 'dart:ui';

import 'package:enactusnca/constant/constants.dart' as constants;
import 'package:enactusnca/model/user_model.dart';
import 'package:enactusnca/services/user_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilScreen extends StatefulWidget {
  final UserModel userModel;

  const EditProfilScreen({this.userModel});

  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  String firstName, lastName, email, department, community;
  File _image;
  String _imgURL;
  bool loading = false;
  List<String> communities = constants.communities;
  List<String> mmDep = constants.mmDep;
  List<String> erDep = constants.erDep;
  List<String> secondList = [];

  @override
  void initState() {
    super.initState();
    if (widget.userModel.community == communities[0]) {
      secondList.addAll(mmDep);
    } else {
      secondList.addAll(erDep);
    }
    community = widget.userModel.community;
    department = widget.userModel.department;
  }

  Future getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _imgURL = pickedFile.hashCode.toString();
      _image = File(pickedFile.path);
    });
    return _image;
  }

  Widget dropDown({List<String> list, String dropdownValue}) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 20,
      elevation: 16,
      style: const TextStyle(color: Colors.grey),
      underline: Container(height: 2),
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
            } else if (newValue == list[5]) {
              secondList.add(communities[5]);
              community = newValue;
              department = null;
            }
          } else {
            department = newValue;
            // ignore: parameter_assignments
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

  Future<void> onSave() async {
    setState(() => loading = true);

    await uploadImage(context).whenComplete(() {
      final UserModel userModel = UserModel(
        firstName: firstName ?? widget.userModel.firstName,
        lastName: lastName ?? widget.userModel.lastName,
        photoUrl: _imgURL ?? widget.userModel.photoUrl,
        email: email ?? widget.userModel.email,
        community: community ?? widget.userModel.community,
        department: community == communities[0] || community == communities[1]
            ? department ?? widget.userModel.department
            : department = null,
      );
      UserServices().updateUserData(userModel);
    }).whenComplete(() {
      setState(() => loading = false);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              "Edit Profile",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  children: [
                    const SizedBox(height: 10),
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
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: _image != null
                                    ? FileImage(_image) as ImageProvider
                                    : NetworkImage(
                                        widget?.userModel?.photoUrl ??
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
                                  border: Border.all(width: 2, color: Colors.white),
                                  color: Theme.of(context).accentColor,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.white),
                                  onPressed: getImage,
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 35.0),
                      child: TextField(
                        onChanged: (String val) => setState(() => firstName = val),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(bottom: 3),
                          labelText: 'FirstName',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: widget.userModel.firstName,
                          hintStyle: const TextStyle(
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
                        onChanged: (String val) => setState(() => lastName = val),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(bottom: 3),
                          labelText: 'lastName',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: widget.userModel.lastName,
                          hintStyle: const TextStyle(
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
                          contentPadding: const EdgeInsets.only(bottom: 3),
                          labelText: 'E-mail',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: widget.userModel.email,
                          hintStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Committee "),
                        dropDown(list: communities, dropdownValue: community),
                      ],
                    ),
                    if (community == communities.elementAt(0) ||
                        community == communities.elementAt(1))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("department "),
                          dropDown(list: secondList, dropdownValue: department),
                        ],
                      )
                    else
                      Container(),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlineButton(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "CANCEL",
                            style: TextStyle(fontSize: 15, letterSpacing: 2.2),
                          ),
                        ),
                        Builder(
                          builder: (context) => RaisedButton(
                            padding: const EdgeInsets.symmetric(horizontal: 50.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Theme.of(context).accentColor,
                            onPressed: onSave,
                            child: const Text(
                              "SAVE",
                              style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 2.2,
                                fontWeight: FontWeight.bold,
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
          ),
        ),
        if (loading == true)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator()),
          )
        else
          Container(),
      ],
    );
  }

  Future uploadImage(BuildContext context) async {
    try {
      final StorageReference ref = FirebaseStorage.instance.ref().child(_imgURL);
      final StorageUploadTask storageUploadTask = ref.putFile(_image);
      final StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(content: Text("Success")),
      // );
      final String url = await taskSnapshot.ref.getDownloadURL() as String;
      setState(() {
        _imgURL = url;
      });
      return url;
    } catch (ex) {
      return;
    }
  }
}

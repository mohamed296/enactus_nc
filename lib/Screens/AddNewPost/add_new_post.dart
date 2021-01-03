import 'dart:io';

import 'package:enactusnca/Models/post.dart';
import 'package:enactusnca/Screens/Home/Home.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/wrapper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddNewPost extends StatefulWidget {
  @override
  _AddNewPostState createState() => _AddNewPostState();
}

class _AddNewPostState extends State<AddNewPost> {
  final Post post = Post();

  String newPost;

  String imageUrl;

  final picker = ImagePicker();

  File _image;
  File file;
  var pickedFile;

  bool showLoadingImage = false;
  bool showLoadingPost = false;

  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  handleTakePhoto() async {
    Navigator.pop(context);
    File file =
        await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }

  handleChoosePhoto() async {
    Navigator.pop(context);
    File file =
        await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }

  selectImage(printcontext) {
    return showDialog(
        context: printcontext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Create Post'),
            children: [
              SimpleDialogOption(
                child: Text('photo with camera'),
                onPressed: handleTakePhoto,
              ),
              SimpleDialogOption(
                child: Text('Image from Gallery'),
                onPressed: handleChoosePhoto,
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create post'),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            //  userInfo(context),
            Column(
              children: <Widget>[
                SizedBox(height: 12.0),
                Container(
                  margin: EdgeInsets.only(left: 12.0, right: 12.0),
                  child: TextField(
                    scrollPadding: EdgeInsets.all(14.0),
                    controller: _controller,
                    maxLines: 8,
                    minLines: 4,
                    keyboardType: TextInputType.multiline,
                    onChanged: (input) => setState(() => newPost = input),
                    decoration: InputDecoration(
                      hintText: 'Enter your Post',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                ),
                addImage(context),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: showLoadingPost == false
            ? Icon(Icons.add, color: KMainColor)
            : SpinKitFoldingCube(color: KMainColor, size: 12.0),
        onPressed: () async {
          if (newPost != null) {
            setState(() => showLoadingPost = true);
            if (imageUrl != null) {
              await uploadImage().then((onComplet) async {
                await post.addNewPost(description: newPost, mediaUrl: imageUrl).then((onComplete) {
                  setState(() => showLoadingPost = false);
                  Fluttertoast.showToast(msg: 'Post add Successfuly.');
                });
              });
            } else {
              await post.addNewPost(description: newPost).whenComplete(() {
                setState(() => showLoadingPost = false);
                Fluttertoast.showToast(msg: 'Post add Successfuly.');
              });
            }
          } else {
            Fluttertoast.showToast(msg: 'Please Type Something');
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Wrapper()),
          );
        },
      ),
    );
  }

  addImage(BuildContext context) {
    return FlatButton(
      child: Container(
        margin: EdgeInsets.only(top: 16.0),
        child: SizedBox(
          height: 300,
          child: ClipRect(
            child: (imageUrl != null)
                ? Image.file(
                    _image,
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                  )
                : (showLoadingImage == false)
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).accentColor,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              'Add Photo',
                              style: TextStyle(color: Theme.of(context).accentColor),
                            ),
                          ],
                        ),
                      )
                    : SpinKitFoldingCube(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      onPressed: () => getImageUrl(),
    );
  }

  Future getImageUrl() async {
    setState(() => showLoadingImage = true);
    pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery)
        .whenComplete(() => setState(() => showLoadingImage = false));
    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.hashCode.toString();
        _image = File(pickedFile.path);
      });
    }
  }

  Future uploadImage() async {
    String fileName = imageUrl;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    dynamic url = await taskSnapshot.ref.getDownloadURL();
    if (url != null) {
      setState(() {
        imageUrl = url;
        showLoadingImage = false;
      });
      print(imageUrl);
      Fluttertoast.showToast(msg: 'Upload image Complete');
    } else {
      setState(() => showLoadingImage = false);
      Fluttertoast.showToast(msg: 'Upload image faild');
    }
  }
}

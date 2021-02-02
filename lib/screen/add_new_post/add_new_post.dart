import 'dart:io';

import 'package:enactusnca/components/constants.dart';
import 'package:enactusnca/model/post.dart';
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
  PickedFile pickedFile;

  bool showLoadingImage = false;
  bool showLoadingPost = false;

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future handleTakePhoto() async {
    Navigator.pop(context);
    final PickedFile file = await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file as File;
    });
  }

  Future handleChoosePhoto() async {
    Navigator.pop(context);
    final PickedFile file = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file as File;
    });
  }

  Future selectImage(BuildContext printcontext) {
    return showDialog(
        context: printcontext,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create Post'),
            children: [
              SimpleDialogOption(
                onPressed: handleTakePhoto,
                child: const Text('photo with camera'),
              ),
              SimpleDialogOption(
                onPressed: handleChoosePhoto,
                child: const Text('Image from Gallery'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
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
        title: const Text('Create post'),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                const SizedBox(height: 12.0),
                Container(
                  margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: TextField(
                    scrollPadding: const EdgeInsets.all(14.0),
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
        onPressed: () async {
          if (newPost != null) {
            setState(() => showLoadingPost = true);
            if (imageUrl != null) {
              await uploadImage().then((onComplet) async {
                await post
                    .addNewPost(description: newPost, mediaUrl: imageUrl)
                    .then((onComplete) {
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
        child: showLoadingPost == false
            ? const Icon(Icons.add, color: kMainColor)
            : const SpinKitFoldingCube(color: kMainColor, size: 12.0),
      ),
    );
  }

  FlatButton addImage(BuildContext context) {
    return FlatButton(
      onPressed: () => getImageUrl(),
      child: Container(
        margin: const EdgeInsets.only(top: 16.0),
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
                          children: <Widget>[
                            Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).accentColor,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              'Add Photo',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                          ],
                        ),
                      )
                    : SpinKitFoldingCube(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
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
    final String fileName = imageUrl;
    final StorageReference reference =
        FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask uploadTask = reference.putFile(_image);
    final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    final dynamic url = await taskSnapshot.ref.getDownloadURL();
    if (url != null) {
      setState(() {
        imageUrl = url as String;
        showLoadingImage = false;
      });
      Fluttertoast.showToast(msg: 'Upload image Complete');
    } else {
      setState(() => showLoadingImage = false);
      Fluttertoast.showToast(msg: 'Upload image faild');
    }
  }
}

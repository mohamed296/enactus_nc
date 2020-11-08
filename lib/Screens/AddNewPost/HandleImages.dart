/*import 'dart:io';

import 'package:enactusnca/Models/Post.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HandleImages extends StatefulWidget {
  static String id = 'HandleImages';

  @override
  _HandleImagesState createState() => _HandleImagesState();
}

class _HandleImagesState extends State<HandleImages> {
  final Post post = Post();
  File file;
  handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }

  handleChoosePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 675, maxWidth: 960);
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

  Container BuildNewPost() {
    return Container(
      color: KSacandColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/bg.jpg',
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: RaisedButton(
              onPressed: () => selectImage(context),
              child: Text(
                'Upload Image',
                style: TextStyle(color: Colors.black26, fontSize: 15),
              ),
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }

  BuildUploadForm() {
    return Text('File loaded');
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? BuildNewPost() : BuildUploadForm();

    /*return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ADD NEW POST'),
      ),
      floatingActionButton: FloatingActionButton(
        child: showLoadingPost == false
            ? Icon(Icons.add, color: Colors.white)
            : SpinKitFoldingCube(color: Colors.white, size: 12.0),
        onPressed: () async {


        /*  if (newPost != null) {
            setState(() => showLoadingPost = true);
            if (imageUrl != null) {
            } else {
              await post.addNewPost(description: newPost).whenComplete(() {
                setState(() => showLoadingPost = false);
                Fluttertoast.showToast(msg: 'Post add Successfuly.');
              });
            }
          } else {
            Fluttertoast.showToast(msg: 'Please Type Something');
          }*/
        },
      ),
    );*/
  }

  /*Future uploadImage() async {
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
  }*/
}
*/
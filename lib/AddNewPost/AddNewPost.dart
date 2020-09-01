/*import 'dart:io';
import 'package:enactusnca/Admin/Bott_admin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enactusnca/Models/Post.dart';
import 'package:enactusnca/Models/User.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';

class AddNewPost extends StatefulWidget {
  static String id = 'AddNewPost';
  final User currentUser;
  AddNewPost({this.currentUser});
  @override
  _AddNewPostState createState() => _AddNewPostState();
}

class _AddNewPostState extends State<AddNewPost> {
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final Post post = Post();
  File file;
  bool isUploading = false;
  String postId = Uuid().v4();

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

  clearImage() {
    setState(() {
      file == true;
    });
  }

  /*Container BuildNewPost() {
    return Container(
       color: KSacandColor,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: RaisedButton(
              onPressed: () => selectImage(context),
              child: Text(
                'Upload Image',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }*/
  Scaffold BuildNewPost() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KMainColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.amber),
          // onPressed: clearImage,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Create Post",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          FlatButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white70,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            ListTile(
              leading: CircleAvatar(
                  /* backgroundImage:
                    CachedNetworkImageProvider(widget.currentUser.photoUrl),*/
                  ),
              title: Container(
                //width: 250.0,
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: TextField(
                  controller: captionController,
                  decoration: InputDecoration(
                    hintText: "Write a post...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.pin_drop,
                color: Colors.orange,
                size: 35.0,
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    hintText: "Where was this photo taken?",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
              width: 200.0,
              alignment: Alignment.center,
              child: RaisedButton.icon(
                label: Text(
                  "Use Current Location",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.blue,
                //  onPressed: getUserLocation,
                icon: Icon(
                  Icons.my_location,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: 200.0,
              alignment: Alignment.center,
              child: RaisedButton.icon(
                label: Text(
                  "Upload Image",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.blue,
                onPressed: () => selectImage(context),
                icon: Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                      /*   decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file),
                    )
                    ),*/
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child("post_$postId.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  createPostInFirestore(
      {String mediaUrl, String location, String description}) {
    postsRef
        .document(widget.currentUser.id)
        .collection("userPosts")
        .document(postId)
        .setData({
      "postId": postId,
      "ownerId": widget.currentUser.id,
      "username": widget.currentUser.username,
      "mediaUrl": mediaUrl,
      "description": description,
      "location": location,
      "timestamp": timestamp,
      "likes": {},
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);
    createPostInFirestore(
      mediaUrl: mediaUrl,
      location: locationController.text,
      description: captionController.text,
    );
    captionController.clear();
    locationController.clear();
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  /* getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
  }*/

  /* Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage),
        title: Text(
          "Caption Post",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          FlatButton(
            //  onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          //    isUploading ? linearProgress() : Text(""),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
                /*  backgroundImage:
                 CachedNetworkImageProvider(widget.currentUser.photoUrl),*/
                ),
            title: Container(
              width: 250.0,
              child: TextField(
                //   controller: captionController,
                decoration: InputDecoration(
                  hintText: "Write a caption...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Colors.orange,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                // controller: locationController,
                decoration: InputDecoration(
                  hintText: "Where was this photo taken?",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: 200.0,
            height: 100.0,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              label: Text(
                "Use Current Location",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.blue,
              //  onPressed: getUserLocation,
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    //return file == null ? BuildNewPost() : buildUploadForm();
    return BuildNewPost();
  }
}
*/

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  final String ownerId;
  final String postId;
  final String userName;
  final String name;
  final String description;
  final String mediaUrl;
  final String userProfileImg;
  final String timeStamp;

  //final dynamic likes;
  int likeCount = 0;
  Map likesList;

  String _dateTime = formatDate(
    DateTime.now(),
    [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn],
  );

  Post({
    this.ownerId,
    this.postId,
    this.userName,
    this.name,
    this.description,
    this.mediaUrl,
    this.userProfileImg,
    this.timeStamp,
    this.likesList,
    this.likeCount,
  });

  Future addNewPost({String description, String mediaUrl}) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final DocumentReference postCollection1 =
        Firestore.instance.collection('Posts').document();
    return postCollection1.setData({
      'ownerId': user.uid,
      'userName': user.displayName,
      'likeCount': likeCount,
      'postId': postCollection1.documentID,
      'name': fullName(user.email),
      'description': description,
      'mediaUrl': mediaUrl,
      'timeStamp': _dateTime.toString(),
      'userProfileImg': user.photoUrl,
    });
  }

  String fullName(String email) {
    String fName;
    DatabaseMethods().getUsersByUserEmail(email).then((val) {
      fName = val.documents[0].data["name"];
      print('new name = $fName');
    });
    return fName;
  }

  List<Post> postsList(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Post(
        postId: doc.documentID,
        ownerId: doc.data['ownerId'],
        userName: doc.data['userName'],
        name: doc.data['name'],
        description: doc.data['description'],
        userProfileImg: doc.data['userProfileImg'],
        mediaUrl: doc.data['mediaUrl'],
        timeStamp: doc.data['timeStamp'],
        likesList: doc['likes'],
        // likeCount: getLikeCount(this.likesList),
      );
    }).toList();
  }

  Stream<List<Post>> get getPosts {
    return postCollection
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map(postsList);
  }
}

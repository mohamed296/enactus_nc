import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  final String ownerId;
  final String postId;
  final String name;
  final String description;
  final String mediaUrl;
  final String userProfileImg;
  final String timeStamp;

  Map likes;
  int likeCount;

  Post({
    this.ownerId,
    this.postId,
    this.name,
    this.description,
    this.mediaUrl,
    this.userProfileImg,
    this.timeStamp,
    this.likes,
    this.likeCount,
  });

  int getLikesCount(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.value.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
  }

  String _dateTime = formatDate(
    DateTime.now(),
    [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn],
  );

  Future<dynamic> addNewPost({String description, String mediaUrl}) async {
    User user = FirebaseAuth.instance.currentUser;
    final postC = FirebaseFirestore.instance.collection('Posts').doc();
    String fName;
    await HelperFunction.getUsername().then((value) => fName = value);
    return await postC.set({
      'ownerId': user.uid,
      'email': user.email,
      'name': fName,
      'likes': {},
      'description': description,
      'mediaUrl': mediaUrl,
      'timeStamp': _dateTime.toString(),
      'userProfileImg': user.photoURL,
    });
  }

  List<Post> postsList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Post(
        postId: doc.id,
        ownerId: doc['ownerId'],
        name: doc['name'],
        description: doc['description'],
        userProfileImg: doc['userProfileImg'],
        mediaUrl: doc['mediaUrl'],
        timeStamp: doc['timeStamp'],
        likes: doc.data()['likes'],
        likeCount: getLikesCount(this.likes),
      );
    }).toList();
  }

  Stream<List<Post>> get getPosts {
    return postCollection.orderBy('timeStamp', descending: true).snapshots().map(postsList);
  }

  toMap() {}

  static fromMap(map) {}
}

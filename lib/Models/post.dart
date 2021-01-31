import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  User user = FirebaseAuth.instance.currentUser;

  final String ownerId;
  final String postId;
  final String name;
  final String description;
  final String mediaUrl;
  final String userProfileImg;
  final String timeStamp;

  Post({
    this.ownerId,
    this.postId,
    this.name,
    this.description,
    this.mediaUrl,
    this.userProfileImg,
    this.timeStamp,
  });

  final String _dateTime = formatDate(
    DateTime.now(),
    [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn],
  );

  Future<dynamic> addNewPost({String description, String mediaUrl}) async {
    final postC = FirebaseFirestore.instance.collection('Posts').doc();
    return postC.set({
      'ownerId': user.uid,
      'email': user.email,
      'name': user.displayName,
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
        ownerId: doc['ownerId'] as String,
        name: doc['name'] as String,
        description: doc['description'] as String,
        userProfileImg: doc['userProfileImg'] as String,
        mediaUrl: doc['mediaUrl'] as String,
        timeStamp: doc['timeStamp'] as String,
      );
    }).toList();
  }

  Stream<List<Post>> get getPosts {
    return postCollection.orderBy('timeStamp', descending: true).snapshots().map(postsList);
  }
}

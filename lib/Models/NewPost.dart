import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:enactusnca/Widgets/constants.dart';
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
  Map likes;
  int likeCount;

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
    this.likes,
    this.likeCount,
  });

  int getLikeCount(likes) {
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

  Future addNewPost({String description, String mediaUrl}) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return await postCollection.document().setData({
      'ownerId': user.uid,
      'userName': user.displayName,
      'name': user.email,
      'description': description,
      'mediaUrl': mediaUrl,
      'timeStamp': _dateTime.toString(),
      'userProfileImg': user.photoUrl,
    });
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
        likes: doc['likes'],
        likeCount: getLikeCount(this.likes),
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

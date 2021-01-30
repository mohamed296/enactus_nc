import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentModel {
  User user = FirebaseAuth.instance.currentUser;

  final String name;
  final String comment;
  final String postUid;
  final String timeStamp;
  final String userImageUrl;

  CommentModel({
    this.name,
    this.comment,
    this.timeStamp,
    this.userImageUrl,
    this.postUid,
  });

  final String _dateTime = formatDate(
    DateTime.now(),
    [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn],
  );

  Future addNewComment({String comment, String postId}) async {
    String fName;
    await HelperFunction.getUsername().then((value) => fName = value);
    return FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('comments')
        .doc()
        .set({
      'postId': postId,
      'comment': comment,
      'userName': fName,
      'userImageUrl': user.photoURL,
      'timeStamp': _dateTime,
    });
  }

  List<CommentModel> commentsList(QuerySnapshot snapshot) {
    return snapshot.docs.map((com) {
      return CommentModel(
        name: com.data()['userName'] as String,
        postUid: com.data()['postId'] as String,
        comment: com.data()['comment'] as String,
        timeStamp: com.data()['timeStamp'] as String,
        userImageUrl: com.data()['userImageUrl'] as String,
      );
    }).toList();
  }
}

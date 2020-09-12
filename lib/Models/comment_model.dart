import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentModel {
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

  String _dateTime = formatDate(
    DateTime.now(),
    [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn],
  );

  Future addNewComment({String comment, String postId}) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String fName;
    await HelperFunction.getUsername().then((value) => fName = value);
    return await Firestore.instance
        .collection('Posts')
        .document(postId)
        .collection('comments')
        .document()
        .setData({
      'postId': postId,
      'comment': comment,
      'userName': fName,
      'userImageUrl': user.photoUrl,
      'timeStamp': _dateTime,
    });
  }

  List<CommentModel> commentsList(QuerySnapshot snapshot) {
    return snapshot.documents.map((com) {
      return CommentModel(
        name: com.data['userName'],
        postUid: com.data['postId'],
        comment: com.data['comment'],
        timeStamp: com.data['timeStamp'] ?? '',
        userImageUrl: com.data['userImageUrl'],
      );
    }).toList();
  }
}

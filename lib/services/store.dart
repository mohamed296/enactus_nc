/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Admin/AddPost.dart';
import 'package:enactusnca/Models/Post.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/Widgets/constants.dart';

class Store {
  final Firestore _firestore = Firestore.instance;

  AddPost(Post post) {
    _firestore.collection(Kpost).add({
      Kpost: post.addNewPost(),
    });

    Future<List<post>> loadPost() async {
      var snapshot = await _firestore.collection(Kpost).getDocuments();
      List<Post> Posts = [];
      for (var doc in snapshot.documents) {
        var data = doc.data;
        Posts.add(Post(
          postId: data[postCollection],
        ));
      }
      return Posts;
    }
  }
}
*/

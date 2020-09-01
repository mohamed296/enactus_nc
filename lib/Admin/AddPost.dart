/*import 'package:enactusnca/Models/Post.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/Widgets/CustomText.dart';
import 'package:enactusnca/services/store.dart';
import 'package:flutter/material.dart';

class AddPost extends StatelessWidget {
  static String id = 'AddPost';

  String _addPost;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _globalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
                onClick: (value) {
                  _addPost = value;
                },
                hint: 'add',
                icon: null),
            //   CustomText(onClick: null, hint: 'add', icon: null),
            //   CustomText(onClick: null, hint: 'add', icon: null),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () {
                if (_globalKey.currentState.validate()) {
                  _globalKey.currentState.save();

                  _store.AddPost(Post(postbody: _addPost));
                }
              },
              child: Text('Added'),
            ),
          ],
        ),
      ),
    );
  }
}*/

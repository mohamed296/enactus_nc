import 'package:enactusnca/Screens/Home/PostTile.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/Models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PostsList extends StatefulWidget {
  final controller;
  PostsList({this.controller});
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Post>>(
      stream: Post().getPosts,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          //  color: Colors.white54,
          child: !snapshot.hasData
              ? Center(
                  child: SpinKitFoldingCube(
                    //  color: Theme.of(context).primaryColor,
                    color: KSacandColor,
                    size: 24.0,
                  ),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: widget.controller,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    // return PostTile(post: snapshot.data[index]);
                    return Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(15.0),
                        elevation: 15.0,
                        shadowColor: KSacandColor.withOpacity(0.2),
                        // shadowColor: KMainColor,
                        child: Container(
                          // width: double.infinity,
                          //  padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.blueGrey, width: 1),
                            borderRadius: BorderRadius.circular(15.0),
                            //  color: Color.fromRGBO(20, 69, 131, 1.0),
                            //   color: Colors.white70
                            color: Color(0xff17335B),
                          ),
                          child: PostTile(post: snapshot.data[index]),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

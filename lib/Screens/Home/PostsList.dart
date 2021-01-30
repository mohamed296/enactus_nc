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
                    color: kSacandColor,
                    size: 24.0,
                  ),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: widget.controller,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    // return PostTile(post: snapshot.data[index]);
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Card(
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        color: Color(0x8022417A),
                        child: PostTile(post: snapshot.data[index]),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

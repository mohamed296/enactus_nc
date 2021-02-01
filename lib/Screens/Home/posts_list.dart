import 'package:enactusnca/models/post.dart';
import 'package:enactusnca/screens/home/post_tile.dart';
import 'package:enactusnca/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PostsList extends StatefulWidget {
  final ScrollController controller;
  const PostsList({
    Key key,
    this.controller,
  }) : super(key: key);
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
          child: !snapshot.hasData
              ? Center(
                  child: SpinKitFoldingCube(color: kSacandColor, size: 24.0))
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: widget.controller,
                  itemCount: snapshot.data.length as int,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        elevation: 15,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        color: const Color(0x8022417A),
                        child: PostTile(post: snapshot.data[index] as Post),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

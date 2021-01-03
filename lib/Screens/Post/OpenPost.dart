import 'package:enactusnca/Models/post.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/Widgets/post_image.dart';
import 'package:flutter/material.dart';

import 'CommentsList.dart';

class OpenPost extends StatefulWidget {
  final focus;
  final Post post;
  OpenPost({this.post, this.focus});

  @override
  _OpenPostState createState() => _OpenPostState();
}

class _OpenPostState extends State<OpenPost> {
  bool showLoading = false;
  String comment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.post.name),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  userinfo(),
                  widget.post.mediaUrl != null
                      ? PostImage(imageUrl: widget.post.mediaUrl)
                      : Container(),
                  Container(
                    margin: EdgeInsets.all(14.0),
                    child: Text(
                      widget.post.description,
                      // style: TextStyle(fontSize: 16.0, color: blackColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          commentsSection(),
        ],
      ),
    );
  }

  userinfo() {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget?.post?.userProfileImg ??
            'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
      ),
      title: Text(widget.post.name),
      subtitle: Text(widget.post.timeStamp),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(
              userId: widget.post.ownerId,
              isAppBarEnabled: true,
            ),
          ),
        );
      },
    );
  }

  commentsSection() {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        minChildSize: 0.2,
        maxChildSize: 1.0,
        initialChildSize: 0.4,
        builder: (context, scrollController) {
          return CommentsList(
            thisPost: widget.post,
            scrollController: scrollController,
            focus: widget.focus,
          );
        },
      ),
    );
  }
}

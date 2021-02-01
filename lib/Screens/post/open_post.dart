import 'package:flutter/material.dart';

import 'package:enactusnca/models/post.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/Widgets/post_image.dart';

import 'comments_list.dart';

class OpenPost extends StatefulWidget {
  final bool focus;
  final Post post;
  const OpenPost({
    Key key,
    this.post,
    this.focus,
  }) : super(key: key);

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                userinfo(),
                if (widget.post.mediaUrl != null)
                  PostImage(imageUrl: widget.post.mediaUrl)
                else
                  Container(),
                Container(
                  margin: const EdgeInsets.all(14.0),
                  child: Text(widget.post.description),
                ),
              ],
            ),
          ),
          commentsSection(),
        ],
      ),
    );
  }

  ListTile userinfo() {
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

  SizedBox commentsSection() {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        minChildSize: 0.2,
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

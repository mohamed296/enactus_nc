import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/components/constants.dart';
import 'package:enactusnca/components/post_image.dart';
import 'package:enactusnca/constant/constants.dart' as constants;
import 'package:enactusnca/constant/helperfunction.dart' as helper_functions;
import 'package:enactusnca/model/post.dart';
import 'package:enactusnca/model/user_model.dart';
import 'package:enactusnca/screen/Profile/profile.dart';
import 'package:enactusnca/screen/post/open_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final UserModel user;

  const PostTile({
    Key key,
    this.post,
    this.user,
  }) : super(key: key);

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  final String currentUser = userCollection?.id;
  final String ownerId;
  final String postId;
  final String userName;
  final String name;
  final String description;
  final String mediaUrl;
  final String userProfileImg;
  final String timeStamp;
  Map likes;
  int likeCount;
  bool isLiked;

  _PostTileState({
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

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    constants.myName = await helper_functions.getUsername();
    constants.myEmail = await helper_functions.getUserEmail();
    constants.myName = await helper_functions.getUsername();
    constants.myId = await helper_functions.getUserId();
  }

  void likePost() {
    final bool _isLiked = likes[constants.myEmail] == true;
    if (_isLiked) {
      FirebaseFirestore.instance
          .collection("Posts")
          .doc(postId)
          .update({'likes.${constants.myEmail}': false});
      setState(() {
        likeCount--;
        isLiked = false;
        likes[constants.myEmail] = false;
      });
    } else {
      FirebaseFirestore.instance
          .collection("Posts")
          .doc(postId)
          .update({'likes.${constants.myEmail}': true});
      setState(() {
        likeCount++;
        isLiked = true;
        likes[constants.myEmail] = true;
      });
    }
  }

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    isLiked = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        userInfo(context),
        postSection(context),
        rowButtons(context),
      ],
    );
  }

  ListTile userInfo(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
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
        child: CircleAvatar(
          radius: 20.0,
          backgroundImage: NetworkImage(
            widget?.post?.userProfileImg ??
                'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
          ),
        ),
      ),
      title: GestureDetector(
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
        child: Text(
          widget.post.name,
          style: TextStyle(
            fontSize: 13,
            color: Colors.amber[300],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: Text(
        widget.post.timeStamp,
        style: TextStyle(
          fontSize: 12,
          color: Colors.amber[100],
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: user.uid == widget.post.ownerId
          ? IconButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('Posts').doc(widget.post.postId).delete();
              },
              icon: const Icon(
                Icons.delete,
                color: kSacandColor,
              ),
            )
          : null,
    );
  }

  InkWell postSection(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OpenPost(
              post: widget.post,
              focus: false,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            child: Text(
              widget.post.description,
              maxLines: 5,
              softWrap: true,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: Colors.amber[300],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (widget.post.mediaUrl != null)
            PostImage(imageUrl: widget.post.mediaUrl)
          else
            Container(),
        ],
      ),
    );
  }

  Column rowButtons(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            const Padding(padding: EdgeInsets.only(top: 40, left: 20)),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OpenPost(
                      post: widget.post,
                      focus: false,
                    ),
                  ),
                );
              },
              child: const Icon(FontAwesomeIcons.comment, size: 25),
            ),
          ],
        ),
      ],
    );
  }
}

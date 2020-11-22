import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Models/post.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/Screens/Post/OpenPost.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/Widgets/PopUpMenu.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/Widgets/post_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final UserModel user;
  final dynamic likes;
  final int likeCount;

  PostTile({this.post, this.user, this.likes, this.likeCount});

  factory PostTile.fromDocument(DocumentSnapshot doc) {
    return PostTile(
      likes: doc['likes'],
    );
  }

  int getLikeCount(likes) {
    if (likes == null) {
      return 0;
    } else {
      int count = 0;
      likes.value.forEach((val) {
        if (val == true) {
          count++;
        }
      });
      return count;
    }
  }

  @override
  _PostTileState createState() => _PostTileState(
        likes: this.likes,
        likeCount: getLikeCount(this.likes),
      );
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
    print(widget.post.mediaUrl);
    getUserInfo();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUsername();
    Constants.myEmail = await HelperFunction.getUserEmail();
    Constants.myName = await HelperFunction.getUsername();
    Constants.myId = await HelperFunction.getUserId();
    print("welcome  ${Constants.myName} ${Constants.myEmail}");
    // setState(() {});
  }

  likePost() {
    bool _isLiked = likes[Constants.myEmail] == true;
    if (_isLiked) {
      FirebaseFirestore.instance
          .collection("Posts")
          .doc(postId)
          .update({'likes.${Constants.myEmail}': false});
      setState(() {
        likeCount--;
        isLiked = false;
        likes[Constants.myEmail] = false;
      });
    } else {
      FirebaseFirestore.instance
          .collection("Posts")
          .doc(postId)
          .update({'likes.${Constants.myEmail}': true});
      setState(() {
        likeCount++;
        isLiked = true;
        likes[Constants.myEmail] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    isLiked = false;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        userInfo(context),
        //Padding(padding: EdgeInsets.only(bottom: 2)),
        postSection(context),
        rowButtons(context),
      ],
    );
  }

  ListTile userInfo(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 34.0,
        backgroundImage: NetworkImage(
          widget?.post?.userProfileImg ??
              'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
        ),
      ),
      //title: Text(post.postId),
      // title: Text(user == null ? post.postId : ''),
      title: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profile(postUserId: widget.post.ownerId),
            ),
          );
        },
        child: Text(
          widget.post.name,
          // style: TextStyle(color: KMainColor),
        ),
      ),

      subtitle: Text(
        widget.post.timeStamp,
        //  style: TextStyle(color: Colors.black),
      ),
      /*  onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(postUserId: post.ownerId),
          ),
        );
      },*/
      /*   trailing: IconButton(
        onPressed: () => print('edit'),
        icon: Icon(
          Icons.delete,
          color: KSacandColor,
        ),
      ), */
    );
  }

  postSection(BuildContext context) {
    return FlatButton(
      onPressed: () {
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            child: Text(
              widget.post.description,
              maxLines: 5,
              softWrap: true,
              overflow: TextOverflow.fade,
              // style: Theme.of(context).textTheme.bodyText2,
              //  style: TextStyle(color: KMainColor)
            ),
          ),
          widget.post.mediaUrl != null
              ? PostImage(imageUrl: widget.post.mediaUrl)
              : Container(),
        ],
      ),
    );
  }

  rowButtons(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 40, left: 20)),
            GestureDetector(
              onTap: () {
                likePost();
              },
              child: Icon(
                isLiked ? LineAwesomeIcons.heart_1 : LineAwesomeIcons.heart,
                // color: KMainColor,
                size: 18.0,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20)),
            GestureDetector(
              //  onTap: () => Navigator.pushNamed(context, CommentCard.id),
              child: Icon(
                FontAwesomeIcons.comment,
                //   color: KMainColor,
                size: 18.0,
              ),
            ),
          ],
        ),
        /*   Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "$ownerId",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(10),
        )*/
      ],
    );
  }

  void select(String choice) {
    if (choice == PopUpMenu.settings) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => Settings(),
      //   ),
      // );
    } else if (choice == PopUpMenu.signOut) {
      //  auth.signOutGoogle(context);
    }
  }
}

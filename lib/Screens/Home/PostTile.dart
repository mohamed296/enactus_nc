import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Models/User.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/Settings/Settings.dart';
import 'package:enactusnca/Widgets/PopUpMenu.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/Widgets/post_image.dart';
import 'package:enactusnca/models/NewPost.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final User user;
  final dynamic likes;
  int likeCount;

  PostTile({this.post, this.user, this.likes, this.likeCount});

  factory PostTile.fromDocument(DocumentSnapshot doc) {
    return PostTile(
      likes: doc['likes'],
    );
  }

  int count = 0;

  editMap(array) {
    int x = 0;
    /*for (int i = 0; i < array.length; i++) {
      if (array[i] == Constants.myEmail) {
        //hnshel asmna
        array.removeAt(i);
      } else {
        //hnzwd asmna
        array.add(Constants.myEmail);
      }
      DatabaseMethods()
          .changeLikeListArray(newArray: array, postId: post.postId);
      return array;
      */ /*if (x >= 2) {
        break;
      } else {
        likes.value.forEach((val) {
          if (array[i] != null) {
            count += 1;
          }
        });
      }*/ /*
    }*/
  }
  //TODO:
  /*getLikesCount() async {
    DatabaseMethods().postData(postId: post.postId).then((val) {});
    Map likes = editMap(array);
  }*/

  @override
  _PostTileState createState() => _PostTileState(
        likes: this.likes,
        likeCount: editMap(this.likes),
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
  Widget build(BuildContext context) {
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
        backgroundImage: AssetImage('assets/images/greg.jpg'),
        //    backgroundImage: NetworkImage(post.userProfileImg),
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
          // post.timeStamp,
          name != null ? name : 'something went wrong',
          style: kTitleTextStyle,
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
      /* trailing: IconButton(
        onPressed: () => print('edit'),
        icon: Icon(
          LineAwesomeIcons.user_edit,
          color: KMainColor,
        ),
      ),*/
      trailing: Padding(
        padding: EdgeInsets.only(
          right: 2.0,
        ),
        child: PopupMenuButton(
          onSelected: select,
          itemBuilder: (context) {
            return PopUpMenu.choices.map((String choice) {
              return PopupMenuItem(
                child: Text(choice),
                value: choice,
              );
            }).toList();
          },
        ),
      ),
    );
  }

  postSection(BuildContext context) {
    return FlatButton(
      /* onPressed: () {
        Navigator.push( context, MaterialPageRoute(builder: (context) => OpenPost(post: widget.post,focus: false,
            ),
          ),
        );
      },*/
      onPressed: () {},
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
              onTap: () {},
              child: Icon(
                LineAwesomeIcons.heart,
                // color: KMainColor,
                size: 18.0,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20)),
            GestureDetector(
              //  onTap: () => Navigator.pushNamed(context, CommentCard.id),
              child: Icon(
                LineAwesomeIcons.comment,
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Settings(),
        ),
      );
    } else if (choice == PopUpMenu.signOut) {
      //  auth.signOutGoogle(context);
    }
  }
}

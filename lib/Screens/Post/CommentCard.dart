import 'package:enactusnca/Models/comment_model.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  static String id = 'CommentCard';
  final CommentModel comment;
  CommentCard({this.comment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(12.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  comment?.userImageUrl ??
                      'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                ),
                radius: 20.0,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12.0),
                margin: EdgeInsets.only(top: 4.0, right: 12.0, bottom: 4.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          comment?.name ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    Text(
                      comment.comment,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 66.0),
          child: Text(
            comment.timeStamp,
          ),
        ),
      ],
    );
  }
}

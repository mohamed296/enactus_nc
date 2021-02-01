import 'package:flutter/material.dart';

import 'package:enactusnca/Models/comment_model.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  const CommentCard({
    Key key,
    this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(12.0),
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
                padding: const EdgeInsets.all(12.0),
                margin: const EdgeInsets.only(top: 4.0, right: 12.0, bottom: 4.0),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    Text(
                      comment.comment,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 66.0),
          child: Text(comment.timeStamp),
        ),
      ],
    );
  }
}

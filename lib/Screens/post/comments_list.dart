import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/models/comment_model.dart';
import 'package:enactusnca/models/notification_model.dart';
import 'package:enactusnca/models/post.dart';
import 'package:enactusnca/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'comment_card.dart';

class CommentsList extends StatefulWidget {
  static String id = 'CommentsList';
  final bool focus;
  final Post thisPost;

  final ScrollController scrollController;

  const CommentsList({this.thisPost, this.scrollController, this.focus});

  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  final _key = GlobalKey<FormState>();

  String newComment;

  bool showLoading = false;

  CommentModel comment = CommentModel();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        addnewComment(),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Posts')
              .doc(widget.thisPost.postId)
              .collection('comments')
              .orderBy('timeStamp', descending: true)
              .snapshots()
              .map(CommentModel().commentsList),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                margin: const EdgeInsets.only(top: 70.0),
                height: 54.0,
                child: const Center(child: Text('No Comments')),
              );
            }
            if (snapshot.hasError) {
              return Container(
                margin: const EdgeInsets.only(top: 70.0),
                height: 54.0,
                child: Center(
                  child: Text('oh! no! we got erroe ${snapshot.error}'),
                ),
              );
            }
            return Container(
              color: Theme.of(context).appBarTheme.color,
              margin: const EdgeInsets.only(top: 110.0),
              child: ListView.builder(
                controller: widget.scrollController,
                itemCount: snapshot.data.length as int,
                itemBuilder: (context, index) {
                  return CommentCard(comment: snapshot.data[index] as CommentModel);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Container addnewComment() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: ListView(
        controller: widget.scrollController,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(8.0),
                child: Text(
                  'Swipe Up For Comments ',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Form(
                  key: _key,
                  child: SizedBox(
                    height: 55.0,
                    child: TextFormField(
                      autofocus: widget.focus,
                      keyboardType: TextInputType.multiline,
                      onChanged: (input) => setState(() => newComment = input),
                      decoration: InputDecoration(
                        hintText: 'Enter Your Comment',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).accentColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).accentColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 55.0,
                  margin: const EdgeInsets.only(left: 4.0, right: 3.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Theme.of(context).accentColor,
                  ),
                  child: IconButton(
                    icon: showLoading == false
                        ? const Icon(Icons.send, color: Colors.white)
                        : SpinKitChasingDots(color: Theme.of(context).accentColor),
                    onPressed: () async {
                      setState(() => showLoading = true);
                      await comment
                          .addNewComment(postId: widget.thisPost.postId, comment: newComment)
                          .then(
                        (done) {
                          final NotificationModel notificationModel = NotificationModel(
                            receiverId: widget.thisPost.ownerId,
                            notificationPost: widget.thisPost,
                          );
                          NotificationServices().sendNotification(
                            notificationModel: notificationModel,
                            like: false,
                          );
                          setState(() => showLoading = false);
                          _key.currentState.reset();
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

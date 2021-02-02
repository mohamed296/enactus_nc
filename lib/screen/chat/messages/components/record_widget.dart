import 'package:enactusnca/constant/constants.dart' as constants;
import 'package:enactusnca/model/messages_model.dart';
import 'package:enactusnca/screen/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'record_player.dart';

class RecordWidget extends StatefulWidget {
  final MessageModel message;

  const RecordWidget({Key key, this.message}) : super(key: key);

  @override
  _RecordWidgetState createState() => _RecordWidgetState();
}

class _RecordWidgetState extends State<RecordWidget> {
  final user = FirebaseAuth.instance.currentUser;

  bool showdate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () => setState(() => showdate = !showdate),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              user.uid != widget.message.senderId ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (user.uid != widget.message.senderId)
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(
                        isAppBarEnabled: true,
                        userId: widget.message.senderId,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12.0),
                  height: 34,
                  width: 34,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: widget.message.userImg != null
                        ? Image.network(
                            widget.message.userImg,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              return loadingProgress == null
                                  ? child
                                  : const Center(child: CircularProgressIndicator());
                            },
                          )
                        : Image.asset('assets/images/enactus.png'),
                  ),
                ),
              )
            else
              Container(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: BoxDecoration(
                color:
                    user.uid != widget.message.senderId ? constants.lightBlue : constants.midBlue,
                borderRadius: user.uid == widget.message.senderId
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      )
                    : const BorderRadius.only(
                        bottomRight: Radius.circular(8.0),
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
              ),
              width: MediaQuery.of(context).size.width * 0.50,
              child: Column(
                children: [
                  Player(url: widget.message.message),
                  const SizedBox(height: 4.0),
                  if (showdate)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        '${widget.message.userName} . ${widget.message.timestamp.toDate().hour.toString()}:${widget.message.timestamp.toDate().minute.toString()}',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w200,
                          color: Colors.grey.shade100,
                        ),
                      ),
                    )
                  else
                    Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

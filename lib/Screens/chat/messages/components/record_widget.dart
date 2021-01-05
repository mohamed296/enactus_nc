import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Models/messages_model.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/Screens/chat/messages/components/record_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecordWidget extends StatefulWidget {
  final MessageModel message;

  RecordWidget({Key key, this.message}) : super(key: key);

  @override
  _RecordWidgetState createState() => _RecordWidgetState();
}

class _RecordWidgetState extends State<RecordWidget> {
  final user = FirebaseAuth.instance.currentUser;

  bool showdate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () => setState(() => showdate = !showdate),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            user.uid != widget.message.senderId
                ? InkWell(
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
                      padding: EdgeInsets.all(12.0),
                      height: 64,
                      width: 64,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(34.0),
                        child: widget.message.userImg != null
                            ? Image.network(
                                widget.message.userImg,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  return loadingProgress == null
                                      ? child
                                      : Center(child: CircularProgressIndicator());
                                },
                              )
                            : Image.asset('assets/images/enactus.png'),
                      ),
                    ),
                  )
                : Container(),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color:
                      user.uid != widget.message.senderId ? Constants.lightBlue : Constants.midBlue,
                  borderRadius: user.uid == widget.message.senderId
                      ? BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        )
                      : BorderRadius.only(
                          bottomRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                ),
                width: MediaQuery.of(context).size.width * 0.50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Player(url: widget.message.message),
                    SizedBox(height: 4.0),
                    showdate
                        ? Padding(
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
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

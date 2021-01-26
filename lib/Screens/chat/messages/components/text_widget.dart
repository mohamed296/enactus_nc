import 'package:auto_direction/auto_direction.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Models/messages_model.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linkwell/linkwell.dart';

class MessageWidget extends StatefulWidget {
  MessageWidget({this.message, this.group, this.seen, this.lastmassage});

  final MessageModel message;
  final bool group;
  final bool seen;
  final String lastmassage;

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final user = FirebaseAuth.instance.currentUser;
  bool showdate = false;
  bool isRTL = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: user.uid == widget.message.senderId
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
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
                  margin: EdgeInsets.only(left: 12.0, bottom: 12.0),
                  height: 34,
                  width: 34,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: widget.message.userImg != null
                        ? Image.network(
                            widget.message.userImg,
                            fit: BoxFit.contain,
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
        GestureDetector(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: widget.message.message));
            Fluttertoast.showToast(
              msg: 'Coped',
              timeInSecForIos: 1,
              backgroundColor: Theme.of(context).primaryColor,
              textColor: Theme.of(context).accentColor,
            );
          },
          onTap: () => setState(() => showdate = !showdate),
          child: Row(
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80),
                decoration: BoxDecoration(
                  color: user.uid != widget.message.senderId
                      ? Constants.lightBlue
                      : Constants.midBlue,
                  borderRadius: user.uid == widget.message.senderId
                      ? BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                        )
                      : BorderRadius.only(
                          topRight: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),
                ),
                margin: EdgeInsets.all(12.0),
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: user.uid == widget.message.senderId
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: <Widget>[
                    AutoDirection(
                      text: widget.message.message,
                      onDirectionChange: (isRTL) =>
                          setState(() => this.isRTL = isRTL),
                      child: LinkWell(
                        widget.message.message,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey.shade100,
                        ),
                        softWrap: true,
                      ),
                    ),
                    showdate == true
                        ? Text(
                            '${widget.message.userName} - ${widget.message.timestamp.toDate().hour.toString()}:${widget.message.timestamp.toDate().minute.toString()}',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w200,
                              color: Colors.grey.shade100,
                            ),
                          )
                        : Container(width: 0, height: 0),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              (widget.lastmassage == widget.message.message)
                  ? widget.group == false
                      ? widget.seen == false
                          ? Icon(Icons.check_circle_outline)
                          : Icon(Icons.check_circle)
                      : Container(
                          width: 0,
                          height: 0,
                        )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

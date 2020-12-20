import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Models/messages_model.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linkwell/linkwell.dart';

class MessageWidget extends StatelessWidget {
  MessageWidget({this.message, this.group});

  final MessageModel message;
  final bool group;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          user.uid == message.senderId ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        user.uid == message.senderId
            ? Container(
                padding: EdgeInsets.all(12.0),
                height: 64,
                width: 64,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(34.0),
                  child: message.userImg != null
                      ? Image.network(
                          message.userImg,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            return loadingProgress == null
                                ? child
                                : Center(child: CircularProgressIndicator());
                          },
                        )
                      : Image.asset('assets/images/enactus.png'),
                ),
              )
            : Container(),
        GestureDetector(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: message.message));
            Fluttertoast.showToast(
              msg: 'Coped',
              timeInSecForIos: 1,
              backgroundColor: Theme.of(context).primaryColor,
              textColor: Theme.of(context).accentColor,
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              color: user.uid != message.senderId ? Constants.lightBlue : Constants.midBlue,
              borderRadius: user.uid == message.senderId
                  ? BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
            ),
            margin: user.uid == message.senderId
                ? EdgeInsets.only(top: 8.0, bottom: 8.0)
                : EdgeInsets.only(top: 8.0, bottom: 8.0),
            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LinkWell(
                  message.message,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade100,
                  ),
                  softWrap: true,
                ),
                SizedBox(height: 8.0),
                Text(
                  '${message.userName} - ${message.timestamp.toDate().hour.toString()}:${message.timestamp.toDate().minute.toString()}',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w200,
                    color: Colors.grey.shade100,
                  ),
                ),
              ],
            ),
          ),
        ),
        user.uid != message.senderId
            ? InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(
                        isAppBarEnabled: true,
                        userId: message.senderId,
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
                    child: message.userImg != null
                        ? Image.network(
                            message.userImg,
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
      ],
    );
  }
}

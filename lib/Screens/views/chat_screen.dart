import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/functions.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/Models/message.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  final String chatRoomId;
  final String lastSender;

  ChatScreen({this.username, this.chatRoomId, this.lastSender});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController tecMessage = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream conversationStream;

  @override
  void initState() {
    super.initState();
    getUserInfo();
    databaseMethods.getConversationMessages(chatRoomId: widget.chatRoomId).then((value) {
      setState(() {
        conversationStream = value;
      });
    });
    if (widget.lastSender != Constants.myName) {
      databaseMethods.markMessageAsSeen(widget.chatRoomId);
    }
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUsername();
    Constants.myEmail = await HelperFunction.getUserEmail();
    Constants.myId = await HelperFunction.getUserId();
    setState(() {});
  }

  sendMessage() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.
      // I am connected to a wifi network.
      if (tecMessage.text.isNotEmpty) {
        final mesgVal = await FirebaseFirestore.instance
            .collection("chatRoom")
            .doc(widget.chatRoomId)
            .collection("chats")
            .add({
          "message": tecMessage.text,
          "sender": Constants.myName,
          "senderId": Constants.myId,
          "time": DateTime.now().millisecondsSinceEpoch,
          "unread": false,
          "isLiked": false,
        }).catchError((error) {
          print("getConversationErrors : ${error.toString()}");
        });
        Map<String, dynamic> chatRoomMap = {
          "lastSender": Constants.myName,
          "lastMessage": tecMessage.text,
          "isRead": false,
          "lastTime": DateTime.now().millisecondsSinceEpoch,
          "chatroomid": widget.chatRoomId,
        };
        databaseMethods.addConversationMessages(
            chatRoomId: widget.chatRoomId, chatConversationMap: chatRoomMap);
        await FirebaseFirestore.instance
            .collection("chatRoom")
            .doc(widget.chatRoomId)
            .collection("chats")
            .doc(mesgVal.id)
            .update({
          "messageId": mesgVal.id,
        }).catchError((error) {
          print("getConversationErrors : ${error.toString()}");
        });
        tecMessage.clear();
      } else {
        Toast.show("You're not connected to the internet", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }

  _buildMessage(MessageTitle message, bool isMe) {
    final Container msg = Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: !isMe ? Constants.lightBlue : Constants.midBlue,
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      margin: isMe
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0),
      padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Functions.readTimestamp(message.time),
            style:
                TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.grey.shade100),
          ),
          SizedBox(height: 8.0),
          Text(
            //message title
            message.message,
            style: TextStyle(
                fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade100),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        Container(
          child: !isMe
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      databaseMethods.changeIsLiked(
                          !message.isLiked, widget.chatRoomId, message.messageId);
                    });
                  },
                  icon: message.isLiked
                      ? Icon(
                          Icons.thumb_up,
                          color: Constants.yellow,
                        )
                      : Icon(
                          Icons.thumb_up,
                          color: Colors.grey.shade400,
                        ),
                )
              : SizedBox.shrink(),
        )
      ],
    );
  }

  _buildMessageComposer() {
    return Container(
      height: 60.0,
      // color: Constants.darkBlue,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            color: Constants.yellow /*Theme.of(context).primaryColor*/,
            onPressed: () {
              //TODO: add the ability to send media files
            },
          ),
          Expanded(
            child: TextField(
              controller: tecMessage,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: Colors.white),
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintStyle: TextStyle(
                  color: Colors.grey.shade100,
                ),
                hintText: "Send a message..",
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Constants.yellow /*Theme.of(context).primaryColor*/,
            onPressed: () {
              sendMessage();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Constants.darkBlue /*Theme.of(context).primaryColor*/,
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 35,
              width: 35,
              child: CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage('assets/images/greg.jpg'),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              widget.username,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                /*Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));*/
              },
            ),
          ],
        ),
        //  backgroundColor: Constants.darkBlue,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    //    color: Constants.darkBlue,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0))),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
                  child: StreamBuilder(
                      stream: conversationStream,
                      builder: (context, snapShot) {
                        return snapShot.hasData
                            ? ListView.builder(
                                reverse: true,
                                padding: EdgeInsets.only(top: 15.0),
                                itemCount: snapShot.data.documents.length,
                                itemBuilder: (context, index) {
                                  UserTitle userTitle = new UserTitle(
                                      name: snapShot.data.documents[index].data["sender"],
                                      userId: snapShot.data.documents[index].data["senderId"]);
                                  MessageTitle message = MessageTitle(
                                    message: snapShot.data.documents[index].data["message"],
                                    isLiked: snapShot.data.documents[index].data["isLiked"],
                                    sender: userTitle,
                                    time: snapShot.data.documents[index].data["time"],
                                    unread: snapShot.data.documents[index].data["unread"],
                                    messageId: snapShot.data.documents[index].data['messageId'],
                                  );
                                  bool isMe = message.sender.userId == Constants.myId;
                                  return _buildMessage(message, isMe);
                                })
                            : Center(
                                child: CircularProgressIndicator(),
                              );
                      }),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}

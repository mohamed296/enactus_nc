import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Models/messages_model.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:enactusnca/services/message_group_services.dart';
import 'package:enactusnca/services/message_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  static String id = 'messages';
  final String username;
  final String groupName;
  final bool group;
  final String chatRoomId;
  final String lastSender;

  Messages({this.username, this.chatRoomId, this.lastSender, this.groupName, this.group});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  TextEditingController tecMessage = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final user = FirebaseAuth.instance.currentUser;
  Stream conversationStream;

  @override
  void initState() {
    super.initState();
    if (widget.group == false) {
      if (widget.lastSender != Constants.myName) {
        databaseMethods.markMessageAsSeen(widget.chatRoomId);
      }
    }
  }

  sendMessage() async {
    MessageModel messageModel = MessageModel(
      groupId: widget.group == true ? widget.groupName : widget.chatRoomId,
      type: 'message',
      message: tecMessage.text,
    );
    widget.group == true
        ? MessageGroupServices()
            .sendGroupMessage(messageModel)
            .catchError((error) => print("getConversationErrors : ${error.toString()}"))
            .whenComplete(() => tecMessage.clear())
        : MessageServices()
            .sendMessage(messageModel)
            .catchError((error) => print("getConversationErrors : ${error.toString()}"))
            .whenComplete(() => tecMessage.clear());
  }

  _buildMessage(MessageModel message) {
    final Container msg = Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: user.uid != message.userId ? Constants.lightBlue : Constants.midBlue,
        borderRadius: user.uid == message.userId
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      margin: user.uid == message.userId
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0),
      padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.group == true
              ? Text(
                  message.userName,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade100,
                  ),
                )
              : Container(),
          SizedBox(height: 8.0),
          Text(
            message.message,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey.shade100,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            '${message.timestamp.toDate().hour.toString()}/${message.timestamp.toDate().minute.toString()}/${message.timestamp.toDate().second.toString()}',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade100,
            ),
          ),
        ],
      ),
    );
    if (user.uid == message.userId) {
      return msg;
    } else {
      return Row(
        children: <Widget>[
          msg,
          Container(
            child: user.uid != message.userId
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        databaseMethods.changeIsLiked(
                            !message.isLiked, widget.chatRoomId, message.messageId);
                      });
                    },
                    icon: message.isLiked
                        ? Icon(Icons.thumb_up, color: Constants.yellow)
                        : Icon(Icons.thumb_up, color: Colors.grey.shade400),
                  )
                : SizedBox.shrink(),
          )
        ],
      );
    }
  }

  _buildMessageComposer() {
    return Container(
      height: 80.0,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            color: Constants.yellow,
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
            color: Constants.yellow,
            onPressed: () => sendMessage(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 35,
              width: 35,
              child: CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage('assets/images/person.png'),
              ),
            ),
            SizedBox(width: 8),
            Text(
              widget.group == true ? widget.groupName : widget.username,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: BackButton(),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_horiz, color: Colors.white),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: widget.group == true
                    ? FirebaseFirestore.instance
                        .collection('GroupChat')
                        .doc(widget.groupName)
                        .collection(widget.groupName)
                        .orderBy("timestamp", descending: true)
                        .snapshots()
                        .map(MessageServices().listOfMessages)
                    : FirebaseFirestore.instance
                        .collection("chatRoom")
                        .doc(widget.chatRoomId)
                        .collection("chats")
                        .orderBy("timestamp", descending: true)
                        .snapshots()
                        .map(MessageServices().listOfMessages),
                builder: (context, snapShot) {
                  return snapShot.hasData
                      ? ListView.builder(
                          reverse: true,
                          padding: EdgeInsets.only(top: 15.0),
                          itemCount: snapShot.data.length,
                          itemBuilder: (context, index) {
                            MessageModel message = MessageModel(
                              groupId: snapShot.data[index].groupId,
                              type: snapShot.data[index].type,
                              userId: snapShot.data[index].userId,
                              userImg: snapShot.data[index].userImg,
                              message: snapShot.data[index].message,
                              isLiked: snapShot.data[index].isLiked,
                              userName: snapShot.data[index].userName,
                              timestamp: snapShot.data[index].timestamp,
                              read: snapShot.data[index].read,
                              messageId: snapShot.data[index].messageId,
                            );
                            return _buildMessage(message);
                          })
                      : Center(child: CircularProgressIndicator());
                },
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}

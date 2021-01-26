import 'dart:io';

import 'package:auto_direction/auto_direction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Models/messages_model.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/Screens/chat/group_member.dart';
import 'package:enactusnca/Screens/chat/messages/components/record_widget.dart';
import 'package:enactusnca/controller/message_controller.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:enactusnca/services/message_group_services.dart';
import 'package:enactusnca/services/message_services.dart';
import 'package:enactusnca/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/image_widget.dart';
import 'components/task_message.dart';
import 'components/task_widget.dart';
import 'components/text_widget.dart';

class Messages extends StatefulWidget {
  static String id = 'messages';
  final String username;
  final String userImg;
  final String groupName;
  final bool group;
  final String chatRoomId;
  final String lastSender;
  final String userId;
  final String imageUrl;
  final bool read;
  final String lastmassage;

  Messages(
      {this.username,
      this.imageUrl,
      this.userId,
      this.chatRoomId,
      this.lastSender,
      this.groupName,
      this.group,
      this.userImg,
      this.read,
      this.lastmassage});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController tecMessage = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  MessageController messageController = MessageController();
  TaskMessage taskMessage = TaskMessage();

  Stream conversationStream;

  bool isRTL = false;
  String text = "";

  bool sending = false;
  bool recording = false;

  @override
  void initState() {
    super.initState();

    if (widget.group == false) {
      if (widget.lastSender != user.displayName) {
        databaseMethods.markMessageAsSeen(widget.chatRoomId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/back.jpg',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.white.withOpacity(0),
          appBar: AppBar(
            backgroundColor: Colors.white.withOpacity(0),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 35,
                  width: 35,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(34.0),
                    child: widget.imageUrl != null
                        ? Image.network(
                            widget.imageUrl,
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
                SizedBox(width: 12.0),
                Text(widget.group == true ? widget.groupName : widget.username),
              ],
            ),
            leading: BackButton(),
            actions: [
              widget.group == true
                  ? IconButton(
                      icon: Icon(Icons.info_outline),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GroupMember(groupName: widget.groupName),
                          ),
                        );
                      },
                    )
                  : Container(),
            ],
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder<List<MessageModel>>(
                  stream: FirebaseFirestore.instance
                      .collection(
                          widget.group == true ? 'GroupChat' : "chatRoom")
                      .doc(widget.group == true
                          ? widget.groupName
                          : widget.chatRoomId)
                      .collection(
                          widget.group == true ? widget.groupName : "chats")
                      .orderBy("timestamp", descending: true)
                      .snapshots()
                      .map(MessageServices().listOfMessages),
                  builder: (context, snapShot) {
                    return snapShot.hasData
                        ? ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.only(top: 15.0),
                            physics: BouncingScrollPhysics(),
                            itemCount: snapShot.data.length,
                            itemBuilder: (context, index) {
                              MessageModel message = MessageModel(
                                groupId: snapShot.data[index].groupId,
                                type: snapShot.data[index].type,
                                receverId: snapShot.data[index].receverId,
                                senderId: snapShot.data[index].senderId,
                                userImg: snapShot.data[index].userImg,
                                message: snapShot.data[index].message,
                                userName: snapShot.data[index].userName,
                                timestamp: snapShot.data[index].timestamp,
                                read: snapShot.data[index].read,
                                messageId: snapShot.data[index].messageId,
                              );
                              return message.type == 'Task'
                                  ? TaskWidget(messageModel: message)
                                  : message.type == 'Message'
                                      ? MessageWidget(
                                          message: message,
                                          group: widget.group,
                                          seen: widget.read,
                                          lastmassage: widget.lastmassage,
                                        )
                                      : message.type == 'Record'
                                          ? RecordWidget(message: message)
                                          : ImageWidget(message: message);
                            })
                        : Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              _buildMessageComposer(),
            ],
          ),
        ),
      ],
    );
  }

  sendMessage({String type, String url}) async {
    MessageModel messageModel = MessageModel(
      receverId: widget.userId,
      groupId: widget.group == true ? widget.groupName : widget.chatRoomId,
      type: type,
      message: type == 'Message' ? tecMessage.text : url,
    );
    tecMessage.clear();
    setState(() => sending = true);

    widget.group == true
        ? MessageGroupServices()
            .sendGroupMessage(messageModel)
            .catchError(
                (error) => print("error in message : ${error.toString()}"))
            .whenComplete(() => setState(() => sending = false))
        : MessageServices()
            .sendMessage(messageModel)
            .catchError(
                (error) => print("error in message : ${error.toString()}"))
            .whenComplete(() => setState(() => sending = false));
  }

  _buildMessageComposer() {
    return StreamBuilder<UserModel>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .snapshots()
          .map(UserServices().userData),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  recording
                      ? Text('Recording..')
                      : sending
                          ? Text('Sending..')
                          : Container(),
                  sending || recording
                      ? LinearProgressIndicator(
                          backgroundColor:
                              recording ? Colors.red : Colors.green,
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Color(0x8022417A),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.image, color: Colors.yellow),
                          onPressed: () async {
                            File image = await messageController.getImage();
                            if (image != null) {
                              setState(() => sending = true);
                              await messageController
                                  .uploadFile(
                                    file: image,
                                    image: true,
                                    fileName: image.path.codeUnits.toString(),
                                  )
                                  .then((url) =>
                                      sendMessage(type: 'image', url: url))
                                  .whenComplete(() {
                                setState(() => sending = false);
                              });
                            }
                            return;
                          },
                        ),
                        (snapshot.data.isHead || snapshot.data.isAdmin) &&
                                widget.groupName != null
                            ? IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(Icons.table_chart),
                                color: Constants.yellow,
                                onPressed: () => taskMessage.showGroupMembers(
                                  context,
                                  widget.groupName,
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            child: Icon(
                              Icons.mic_rounded,
                              color: recording ? Colors.red : Colors.yellow,
                            ),
                            onLongPress: () {
                              setState(() => recording = true);
                              messageController.startRecording();
                            },
                            onLongPressUp: () {
                              setState(() {
                                recording = false;
                                sending = true;
                              });
                              String chatId =
                                  widget?.chatRoomId ?? widget.groupName;
                              messageController
                                  .stopRecording(chatId)
                                  .then((url) {
                                if (url != null) {
                                  sendMessage(type: 'Record', url: url);
                                }
                              }).whenComplete(
                                      () => setState(() => sending = false));
                            },
                          ),
                        ),
                        Expanded(
                          child: AutoDirection(
                            text: text,
                            onDirectionChange: (isRTL) =>
                                setState(() => this.isRTL = isRTL),
                            child: TextField(
                              controller: tecMessage,
                              textCapitalization: TextCapitalization.sentences,
                              scrollPhysics: BouncingScrollPhysics(),
                              style: TextStyle(color: Colors.white),
                              maxLines: 4,
                              minLines: 1,
                              onChanged: (value) =>
                                  setState(() => text = value),
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration.collapsed(
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade100),
                                hintText: "Aa",
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.send),
                          color: Constants.yellow,
                          onPressed: () => sendMessage(type: 'Message'),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator();
      },
    );
  }
}

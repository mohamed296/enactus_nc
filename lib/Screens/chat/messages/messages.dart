import 'dart:io';

import 'package:auto_direction/auto_direction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  const Messages({
    Key key,
    this.username,
    this.userImg,
    this.groupName,
    this.group,
    this.chatRoomId,
    this.lastSender,
    this.userId,
    this.imageUrl,
    this.read,
    this.lastmassage,
  }) : super(key: key);

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
  Timestamp lastMessageTime;

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
  void dispose() {
    if (widget.group) saveLastMessageTimeSeen();
    tecMessage.dispose();
    super.dispose();
  }

  Future<void> saveLastMessageTimeSeen() async {
    final listOfMessage = await FirebaseFirestore.instance
        .collection('GroupChat')
        .doc(widget.groupName)
        .collection(widget.groupName)
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();
    FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
      '${widget.groupName} time': listOfMessage.docs.last.data()['timestamp'],
    });
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
                SizedBox(
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
                                  : const Center(child: CircularProgressIndicator());
                            },
                          )
                        : Image.asset('assets/images/enactus.png'),
                  ),
                ),
                const SizedBox(width: 12.0),
                Text(widget.group == true ? widget.groupName : widget.username),
              ],
            ),
            leading: const BackButton(),
            actions: [
              if (widget.group == true)
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupMember(groupName: widget.groupName),
                      ),
                    );
                  },
                )
              else
                Container(),
            ],
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder<List<MessageModel>>(
                  stream: FirebaseFirestore.instance
                      .collection(widget.group == true ? 'GroupChat' : "chatRoom")
                      .doc(widget.group == true ? widget.groupName : widget.chatRoomId)
                      .collection(widget.group == true ? widget.groupName : "chats")
                      .orderBy("timestamp", descending: true)
                      .snapshots()
                      .map(MessageServices().listOfMessages),
                  builder: (context, snapShot) {
                    lastMessageTime = snapShot.data.last.timestamp;
                    return snapShot.hasData
                        ? ListView.builder(
                            reverse: true,
                            padding: const EdgeInsets.only(top: 15.0),
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapShot.data.length,
                            itemBuilder: (context, index) {
                              final MessageModel message = MessageModel(
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
                        : const Center(child: CircularProgressIndicator());
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

  Future<void> sendMessage({String type, String url}) async {
    final MessageModel messageModel = MessageModel(
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
            .whenComplete(() => setState(() => sending = false))
        : MessageServices()
            .sendMessage(messageModel)
            .whenComplete(() => setState(() => sending = false));
  }

  StreamBuilder<UserModel> _buildMessageComposer() => StreamBuilder<UserModel>(
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
                    if (recording)
                      const Text('Recording..')
                    else
                      sending ? const Text('Sending..') : Container(),
                    if (sending || recording)
                      LinearProgressIndicator(
                        backgroundColor: recording ? Colors.red : Colors.green,
                      )
                    else
                      Container(),
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color(0x8022417A),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(Icons.image, color: Colors.yellow),
                            onPressed: () async {
                              final File image = await messageController.getImage();
                              if (image != null) {
                                setState(() => sending = true);
                                await messageController
                                    .uploadFile(
                                      file: image,
                                      image: true,
                                      fileName: image.path.codeUnits.toString(),
                                    )
                                    .then((url) => sendMessage(type: 'image', url: url as String))
                                    .whenComplete(() => setState(() => sending = false));
                              }
                              return;
                            },
                          ),
                          if ((snapshot.data.isHead || snapshot.data.isAdmin) &&
                              widget.groupName != null)
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(Icons.table_chart),
                              color: Constants.yellow,
                              onPressed: () => taskMessage.showGroupMembers(
                                context,
                                widget.groupName,
                              ),
                            )
                          else
                            Container(),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onLongPress: () {
                                setState(() => recording = true);
                                messageController.startRecording();
                              },
                              onLongPressUp: () {
                                setState(() {
                                  recording = false;
                                  sending = true;
                                });
                                final String chatId = widget?.chatRoomId ?? widget.groupName;
                                messageController.stopRecording(chatId).then((url) {
                                  if (url != null) {
                                    sendMessage(type: 'Record', url: url as String);
                                  }
                                }).whenComplete(() => setState(() => sending = false));
                              },
                              child: Icon(
                                Icons.mic_rounded,
                                color: recording ? Colors.red : Colors.yellow,
                              ),
                            ),
                          ),
                          Expanded(
                            child: AutoDirection(
                              text: text,
                              onDirectionChange: (isRTL) => setState(() => this.isRTL = isRTL),
                              child: TextField(
                                controller: tecMessage,
                                textCapitalization: TextCapitalization.sentences,
                                scrollPhysics: const BouncingScrollPhysics(),
                                style: const TextStyle(color: Colors.white),
                                maxLines: 4,
                                minLines: 1,
                                onChanged: (value) => setState(() => text = value),
                                textInputAction: TextInputAction.newline,
                                decoration: InputDecoration.collapsed(
                                  hintStyle: TextStyle(color: Colors.grey.shade100),
                                  hintText: "Aa",
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(Icons.send),
                            color: Constants.yellow,
                            onPressed: () => sendMessage(type: 'Message'),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator());
        },
      );
}

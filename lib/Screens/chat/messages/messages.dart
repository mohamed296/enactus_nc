import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Models/messages_model.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/Screens/chat/group_member.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:enactusnca/services/message_group_services.dart';
import 'package:enactusnca/services/message_services.dart';
import 'package:enactusnca/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Messages extends StatefulWidget {
  static String id = 'messages';
  final String username;
  final String userImg;
  final String groupName;
  final bool group;
  final String chatRoomId;
  final String lastSender;
  final String imageUrl;
  Messages({
    this.username,
    this.imageUrl,
    this.chatRoomId,
    this.lastSender,
    this.groupName,
    this.group,
    this.userImg,
  });

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  TextEditingController tecMessage = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final user = FirebaseAuth.instance.currentUser;
  Stream conversationStream;
  DateTime selectedDate = DateTime.now();

  File _image;
  String _imgURL;
  String senimage = '';
  bool sendim = false;

  @override
  void initState() {
    super.initState();
    if (widget.group == false) {
      if (widget.lastSender != Constants.myName) {
        databaseMethods.markMessageAsSeen(widget.chatRoomId);
      }
    }
  }

  Future getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imgURL = pickedFile.hashCode.toString();
        _image = File(pickedFile.path);
      });
    }

    return _image;
  }

  Future uploadImage(BuildContext context) async {
    try {
      StorageReference ref = FirebaseStorage.instance.ref().child(_imgURL);
      StorageUploadTask storageUploadTask = ref.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

      String url = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        _imgURL = url;
        senimage = url;
        sendim = true;
      });
      return url;
    } catch (ex) {}
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019, 8),
      lastDate: DateTime(2100),
      useRootNavigator: true,
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  sendMessage(
      {String type,
      DateTime dateTime,
      UserModel userModel,
      bool sendNotification}) async {
    MessageModel messageModel = MessageModel(
      userId: type == 'Task' ? userModel.id : null,
      userImg: userModel?.photoUrl ?? null,
      userName: userModel?.username ?? null,
      groupId: widget.group == true ? widget.groupName : widget.chatRoomId,
      type: type,
      message: type == 'Message'
          ? tecMessage.text
          : type == 'Task'
              ? dateTime.toString()
              : type == 'image'
                  ? senimage
                  : null,
    );
    widget.group == true
        ? type == 'Task'
            ? MessageGroupServices()
                .sendTaskMessage(messageModel, dateTime, sendNotification)
                .catchError((error) =>
                    print("getConversationErrors : ${error.toString()}"))
                .whenComplete(() => tecMessage.clear())
            : MessageGroupServices()
                .sendGroupMessage(messageModel)
                .catchError((error) =>
                    print("getConversationErrors : ${error.toString()}"))
                .whenComplete(() => tecMessage.clear())
        : MessageServices()
            .sendMessage(messageModel)
            .catchError(
                (error) => print("getConversationErrors : ${error.toString()}"))
            .whenComplete(() => tecMessage.clear());
  }

  void showGroupMembers(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      elevation: 1.0,
      isDismissible: true,
      clipBehavior: Clip.antiAlias,
      backgroundColor: Theme.of(context).primaryColor,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Assign Task To'),
                leading: Container(),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.done_all_rounded),
                onPressed: () {
                  _selectDate(context).then((dataTime) {
                    final UserModel taskUser = UserModel(username: 'All');
                    sendMessage(
                      dateTime: selectedDate,
                      type: 'Task',
                      userModel: taskUser,
                      sendNotification: false,
                    );
                  }).whenComplete(() => Navigator.pop(context));
                },
              ),
              body: StreamBuilder<List<UserModel>>(
                stream: FirebaseFirestore.instance
                    .collection('GroupChat')
                    .doc(widget.groupName)
                    .collection('members')
                    .snapshots()
                    .map(MessageGroupServices().listOfMembers),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) => ListTile(
                            onTap: () => _selectDate(context).then((dataTime) {
                              final UserModel taskUser = UserModel(
                                id: snapshot.data[index].id,
                                username: snapshot.data[index].username,
                                photoUrl: snapshot.data[index].photoUrl,
                              );
                              sendMessage(
                                type: 'Task',
                                dateTime: selectedDate,
                                userModel: taskUser,
                                sendNotification: true,
                              );
                            }).whenComplete(() => Navigator.pop(context)),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: snapshot.data[index].photoUrl ==
                                      null
                                  ? AssetImage("assets/images/person.png")
                                  : NetworkImage(snapshot.data[index].photoUrl),
                            ),
                            title:
                                Text(snapshot?.data[index]?.username ?? 'user'),
                            subtitle: snapshot.data[index].isHead
                                ? Text('Head')
                                : Text('Member'),
                          ),
                        )
                      : CircularProgressIndicator();
                },
              ),
            );
          },
        );
      },
    );
  }

  _buildMessage(MessageModel message) {
    return message.type == 'Task'
        ? Container(
            margin: const EdgeInsets.only(left: 54.0, bottom: 6.0),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.list_alt),
                    SizedBox(width: 12.0),
                    Text(
                      'Task assigned to',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 12.0),
                    Text(
                      message.userName,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                Container(
                  color: Colors.yellow,
                  child: Row(
                    children: [
                      Icon(
                        Icons.date_range_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(width: 12.0),
                      Text(
                        message.message,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        : Row(
            mainAxisAlignment: user.uid == message.userId
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              user.uid == message.userId
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
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  return loadingProgress == null
                                      ? child
                                      : Center(
                                          child: CircularProgressIndicator());
                                },
                              )
                            : Image.asset('assets/images/enactus.png'),
                      ),
                    )
                  : Container(),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: user.uid != message.userId
                      ? Constants.lightBlue
                      : Constants.midBlue,
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
                    ? EdgeInsets.only(top: 8.0, bottom: 8.0)
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
                              fontWeight: FontWeight.w400,
                              color: Colors.blueGrey.shade100,
                            ),
                          )
                        : Container(),
                    SizedBox(height: 8.0),
                    (sendim == true)
                        ? Image.network(senimage)
                        : Text(
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
                        fontWeight: FontWeight.w200,
                        color: Colors.grey.shade100,
                      ),
                    ),
                  ],
                ),
              ),
              user.uid != message.userId
                  ? InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(
                              isAppBarEnabled: true,
                              userId: message.userId,
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
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    return loadingProgress == null
                                        ? child
                                        : Center(
                                            child: CircularProgressIndicator());
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
                  Divider(color: Colors.yellow, height: 1.0, thickness: 0.5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.image,
                              color: Colors.yellow,
                            ),
                            onPressed: () async {
                              getImage();

                              await uploadImage(context).then(
                                (url) => sendMessage(type: 'image'),
                              );
                            }),
                        Expanded(
                          child: TextField(
                            controller: tecMessage,
                            textCapitalization: TextCapitalization.sentences,
                            scrollPhysics: BouncingScrollPhysics(),
                            style: TextStyle(color: Colors.white),
                            maxLines: 6,
                            minLines: 1,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {},
                            decoration: InputDecoration.collapsed(
                              hintStyle: TextStyle(color: Colors.grey.shade100),
                              hintText: "Type a message...",
                            ),
                          ),
                        ),
                        snapshot.data.isHead ||
                                snapshot.data.isAdmin &&
                                    widget.groupName != null
                            ? IconButton(
                                icon: Icon(Icons.table_chart),
                                color: Constants.yellow,
                                onPressed: () => showGroupMembers(context),
                              )
                            : Container(),
                        IconButton(
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
              : Container()
        ],
      ),
      body: Column(
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
    );
  }
}

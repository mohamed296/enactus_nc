import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Models/messages_model.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/controller/message_controller.dart';
import 'package:enactusnca/services/message_group_services.dart';
import 'package:flutter/material.dart';

class TaskMessage {
  MessageController messageController = MessageController();
  sendTask({UserModel user, BuildContext context, String groupId}) async {
    final DateTime date = await messageController.selectDate(context);

    final MessageModel messageModel = MessageModel(
      receverId: user?.id,
      userName: user == null ? 'All' : user.username,
      groupId: groupId,
      type: 'Task',
      message: date.toString(),
    );

    MessageGroupServices()
        .sendTaskMessage(messageModel, date, true)
        .catchError(
            (error) => print("Error on send task : ${error.toString()}"))
        .whenComplete(() => Navigator.pop(context));
  }

  void showGroupMembers(BuildContext context, String groupId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
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
                  title: const Text('Assign Task To'), leading: Container()),
              floatingActionButton: FloatingActionButton(
                onPressed: () => sendTask(),
                child: const Icon(Icons.done_all_rounded),
              ),
              body: StreamBuilder<List<UserModel>>(
                stream: FirebaseFirestore.instance
                    .collection('GroupChat')
                    .doc(groupId)
                    .collection('members')
                    .snapshots()
                    .map(MessageGroupServices().listOfMembers),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) => ListTile(
                            onTap: () =>
                                messageController.selectDate(context).then(
                              (dataTime) {
                                final UserModel taskUser = UserModel(
                                  id: snapshot.data[index].id,
                                  username: snapshot.data[index].username,
                                  photoUrl: snapshot.data[index].photoUrl,
                                );
                                sendTask(user: taskUser);
                              },
                            ),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: snapshot.data[index].photoUrl ==
                                      null
                                  ? const AssetImage("assets/images/person.png")
                                  : NetworkImage(snapshot.data[index].photoUrl),
                            ),
                            title:
                                Text(snapshot?.data[index]?.username ?? 'user'),
                            subtitle: snapshot.data[index].isHead
                                ? const Text('Head')
                                : const Text('Member'),
                          ),
                        )
                      : const CircularProgressIndicator();
                },
              ),
            );
          },
        );
      },
    );
  }
}

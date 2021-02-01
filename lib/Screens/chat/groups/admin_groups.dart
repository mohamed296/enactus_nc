import 'package:badges/badges.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Models/list_of_groups.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/Screens/chat/messages/messages.dart';
import 'package:enactusnca/controller/message_group_controller.dart';
import 'package:enactusnca/services/message_group_services.dart';
import 'package:flutter/material.dart';

class AdminGroups extends StatelessWidget {
  final UserModel userModel;

  const AdminGroups({Key key, this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ListOfGroups>>(
      stream: MessageGroupServices().getGroupsList,
      builder: (context, groupListSnapshot) {
        return groupListSnapshot.hasData
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: groupListSnapshot.data.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<bool>(
                    future: MessageGroupController().getMessageCountChange(
                        groupListSnapshot.data[index].groupName),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? const Center(child: CircularProgressIndicator())
                          : Container(
                              margin: const EdgeInsets.only(
                                top: 5.0,
                                bottom: 5.0,
                                right: 20.0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              decoration: BoxDecoration(
                                color: Constants.midBlue,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: ListTile(
                                leading: Badge(
                                  showBadge: snapshot.data,
                                  badgeContent: const Text(''),
                                  badgeColor: Constants.yellow,
                                  child: SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(35.0),
                                      child: Image.asset(
                                          'assets/images/enactus.png'),
                                    ),
                                  ),
                                ),
                                title: Text(
                                    groupListSnapshot.data[index].groupName),
                                subtitle: Text(
                                    groupListSnapshot.data[index].lastMessage,
                                    maxLines: 1),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Messages(
                                      group: true,
                                      userId: groupListSnapshot
                                          .data[index].groupName,
                                      groupName: groupListSnapshot
                                          .data[index].groupName,
                                    ),
                                  ),
                                ),
                              ),
                            );
                    },
                  );
                },
              )
            : const CircularProgressIndicator();
      },
    );
  }
}

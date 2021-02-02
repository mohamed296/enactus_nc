import 'package:enactusnca/model/list_of_groups.dart';
import 'package:enactusnca/model/user_model.dart';
import 'package:enactusnca/screen/chat/messages/messages.dart';
import 'package:enactusnca/services/message_group_services.dart';
import 'package:flutter/material.dart';

import 'group_tile.dart';

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
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12.0),
                      GroupTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Messages(
                              group: true,
                              userId: groupListSnapshot.data[index].groupName,
                              groupName: groupListSnapshot.data[index].groupName,
                            ),
                          ),
                        ),
                        lastMessage: groupListSnapshot.data[index].lastMessage,
                        groupName: groupListSnapshot.data[index].groupName,
                      ),
                    ],
                  );
                },
              )
            : const CircularProgressIndicator();
      },
    );
  }
}

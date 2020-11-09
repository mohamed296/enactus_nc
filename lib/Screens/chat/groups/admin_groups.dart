import 'package:enactusnca/Models/list_of_groups.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/Screens/chat/messages/messages.dart';
import 'package:enactusnca/services/message_group_services.dart';
import 'package:flutter/material.dart';

class AdminGroups extends StatelessWidget {
  final UserModel userModel;

  const AdminGroups({Key key, this.userModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ListOfGroups>>(
      stream: MessageGroupServices().getGroupsList,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(34.0),
                      child: Container(
                        color: Colors.yellow,
                        height: 44,
                        width: 44,
                      ),
                    ),
                    title: Text(snapshot.data[index].groupName),
                    subtitle: Text('${snapshot.data[index].lastMessage}'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Messages(
                          group: true,
                          groupName: snapshot.data[index].groupName,
                        ),
                      ),
                    ),
                  );
                },
              )
            : CircularProgressIndicator();
      },
    );
  }
}

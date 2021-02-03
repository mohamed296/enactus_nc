import 'package:badges/badges.dart';
import 'package:enactusnca/controller/message_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:enactusnca/constant/constants.dart' as constants;

class GroupTile extends StatelessWidget {
  final VoidCallback onTap;
  final String groupName;
  final String lastMessage;
  const GroupTile({
    Key key,
    this.onTap,
    this.groupName,
    this.lastMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: MessageGroupController().getMessageCountChange(groupName),
      builder: (context, snapshot) {
        final bool showBadge = snapshot.data as bool;
        return snapshot.hasData
            ? Container(
                margin: const EdgeInsets.only(right: 34.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: constants.darkBlue,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: InkWell(
                  onTap: onTap,
                  child: Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        margin: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(34.0),
                          child: Image.asset('assets/images/enactus.png'),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Badge(
                              showBadge: showBadge,
                              badgeContent: const Icon(
                                Icons.email_outlined,
                                color: Colors.yellow,
                              ),
                              alignment: Alignment.centerLeft,
                              position: BadgePosition.topEnd(end: -44.0),
                              badgeColor: constants.lightBlue,
                              elevation: 16,
                              child: Text(groupName)),
                          const SizedBox(height: 6.0),
                          Text(
                            lastMessage,
                            maxLines: 1,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}

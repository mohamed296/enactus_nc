import 'package:enactusnca/Models/notification_model.dart';
import 'package:enactusnca/Screens/Notifications/notification_tile.dart';
import 'package:enactusnca/services/notification_services.dart';
import 'package:flutter/material.dart';

class NotificationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<NotificationModel>>(
        stream: NotificationServices().getNotificationList,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return NotificationTile(notificationModel: snapshot.data[index]);
                  },
                )
              : CircularProgressIndicator();
        },
      ),
    );
  }
}

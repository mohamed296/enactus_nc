import 'package:enactusnca/Models/notification_model.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/services/notification_services.dart';
import 'package:flutter/material.dart';

import 'notification_tile.dart';

class Notifications extends StatelessWidget {
  static String id = 'notifications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Notifications',
            style: TextStyle(fontSize: 20.0, color: KSacandColor)),
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: NotificationServices().getNotificationList,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return NotificationTile(
                        notificationModel: snapshot.data[index]);
                  },
                )
              : CircularProgressIndicator();
        },
      ),
    );
  }
}

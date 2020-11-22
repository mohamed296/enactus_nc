import 'package:enactusnca/Models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notificationModel;

  const NotificationTile({Key key, this.notificationModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: notificationModel.senderImg != null
            ? Image.network(
                notificationModel.senderImg,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  return loadingProgress == null
                      ? child
                      : Center(child: CircularProgressIndicator());
                },
              )
            : Icon(Icons.calendar_today), //Image.asset('assets/images/enactus.png'),
      ),
      title: Text(notificationModel.notificationMsg),
      subtitle: Text(notificationModel.notificationTime),
    );
  }
}

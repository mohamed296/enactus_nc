import 'package:enactusnca/model/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notificationModel;

  const NotificationTile({Key key, this.notificationModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          SizedBox(
            height: 34,
            width: 34,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: notificationModel.senderImg != null
                  ? Image.network(
                      notificationModel.senderImg,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        return loadingProgress == null
                            ? child
                            : const Center(child: CircularProgressIndicator());
                      },
                    )
                  : const Icon(Icons.calendar_today),
            ),
          ),
          const SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notificationModel.notificationMsg),
              Text(notificationModel.notificationTime),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:enactusnca/Models/messages_model.dart';
import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({this.messageModel, Key key}) : super(key: key);

  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 54.0, bottom: 6.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.list_alt),
              SizedBox(width: 12.0),
              Text('Task assigned to', style: TextStyle(color: Colors.black)),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.person),
              const SizedBox(width: 12.0),
              Text(messageModel.userName,
                  style: const TextStyle(color: Colors.black)),
            ],
          ),
          Container(
            color: Colors.yellow,
            child: Row(
              children: [
                const Icon(Icons.date_range_rounded, color: Colors.white),
                const SizedBox(width: 12.0),
                Text(messageModel.message,
                    style: const TextStyle(color: Colors.black)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

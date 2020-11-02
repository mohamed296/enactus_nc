import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  static String id = 'notifications';
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                'Notifications',
                style: TextStyle(fontSize: 20.0),
              ),
              bottom: TabBar(tabs: <Widget>[Text('All'), Text('Groups')]),
            ),
          ),
        ),
      ],
    );
  }
}

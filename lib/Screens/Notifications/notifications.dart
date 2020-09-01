import 'package:enactusnca/Widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class notifications extends StatefulWidget {
  static String id = 'notifications';
  @override
  _notificationsState createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
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

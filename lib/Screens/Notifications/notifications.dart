import 'package:enactusnca/Screens/Notifications/notification_list.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  static String id = 'notifications';
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(fontSize: 20.0),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[Tab(text: 'All'), Tab(text: 'Groups')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NotificationList(),
          Text('test'),
        ],
      ),
    );
  }
}

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:enactusnca/Screens/Home/Home.dart';
import 'package:enactusnca/Screens/Notifications/notifications.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/Screens/chat/chat.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

@override
class _WrapperState extends State<Wrapper> {
  int _currentIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    Home(),
    Notifications(),
    const Profile(),
    Chat(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _widgetOptions,
          ),
          bottomNavigationBar: BottomNavyBar(
            curve: Curves.ease,
            backgroundColor: const Color(0xff0C1E34),
            selectedIndex: _currentIndex,
            onItemSelected: (index) => setState(() => _currentIndex = index),
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                title: const Center(
                    child: Text('home', style: TextStyle(color: kSacandColor))),
                icon:
                    const Center(child: Icon(Icons.home, color: kSacandColor)),
              ),
              BottomNavyBarItem(
                title: const Center(
                    child: Text('notifications',
                        style: TextStyle(color: kSacandColor))),
                icon: const Center(
                    child: Icon(Icons.notifications, color: kSacandColor)),
              ),
              BottomNavyBarItem(
                title: const Center(
                    child: Text(' Profile',
                        style: TextStyle(color: kSacandColor))),
                icon: const Center(
                    child: Icon(Icons.portrait, color: kSacandColor)),
              ),
              BottomNavyBarItem(
                title: const Center(
                    child: Text('chat', style: TextStyle(color: kSacandColor))),
                icon:
                    const Center(child: Icon(Icons.chat, color: kSacandColor)),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class MYpopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      color: kSacandColor,
      onSelected: (Menu option) {},
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<Menu>>[
          const PopupMenuItem(
            value: Menu.Settings,
            child: Text('Setting'),
          ),
          const PopupMenuItem(
            value: Menu.About,
            child: Text('About'),
          ),
          const PopupMenuItem(
            value: Menu.Aboutt,
            child: Text('Aboutt'),
          ),
        ];
      },
    );
  }
}

enum Menu {
  Settings,
  About,
  Aboutt,
}

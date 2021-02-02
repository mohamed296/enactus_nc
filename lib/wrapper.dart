import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:enactusnca/screen/Profile/profile.dart';
import 'package:flutter/material.dart';

import 'components/constants.dart';
import 'screen/Notifications/notifications.dart';
import 'screen/chat/chat.dart';
import 'screen/enactus_main/enactus_main.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

@override
class _WrapperState extends State<Wrapper> {
  int _currentIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    EnactusMain(),
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
                title: const Center(child: Text('home', style: TextStyle(color: kSacandColor))),
                icon: const Center(child: Icon(Icons.home, color: kSacandColor)),
              ),
              BottomNavyBarItem(
                title: const Center(
                    child: Text('notifications', style: TextStyle(color: kSacandColor))),
                icon: const Center(child: Icon(Icons.notifications, color: kSacandColor)),
              ),
              BottomNavyBarItem(
                title: const Center(child: Text(' Profile', style: TextStyle(color: kSacandColor))),
                icon: const Center(child: Icon(Icons.portrait, color: kSacandColor)),
              ),
              BottomNavyBarItem(
                title: const Center(child: Text('chat', style: TextStyle(color: kSacandColor))),
                icon: const Center(child: Icon(Icons.chat, color: kSacandColor)),
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
            value: Menu.settings,
            child: Text('Setting'),
          ),
          const PopupMenuItem(
            value: Menu.about,
            child: Text('About'),
          ),
          const PopupMenuItem(
            value: Menu.aboutt,
            child: Text('Aboutt'),
          ),
        ];
      },
    );
  }
}

enum Menu {
  settings,
  about,
  aboutt,
}

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:enactusnca/Screens/Home/Home.dart';
import 'package:enactusnca/Screens/Notifications/notifications.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/Screens/chat/chat.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:flutter/material.dart';

// final StorageReference storageRef = FirebaseStorage.instance.ref();
// final usersRef = FirebaseFirestore.instance.collection('users');
// final postsRef = FirebaseFirestore.instance.collection('posts');
// final commentsRef = FirebaseFirestore.instance.collection('comments');
// final activityFeedRef = FirebaseFirestore.instance.collection('feed');
// final timelineRef = FirebaseFirestore.instance.collection('timeline');
// final DateTime timestamp = DateTime.now();
// UserModel currentUser;

class Wrapper extends StatefulWidget {
  static String id = 'wrapper';

  @override
  _WrapperState createState() => _WrapperState();
}

@override
class _WrapperState extends State<Wrapper> {
  int _currentIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    Home(),
    Notifications(),
    Profile(),
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
            showElevation: true,
            curve: Curves.ease,
            backgroundColor: kDarkColor,
            selectedIndex: _currentIndex,
            onItemSelected: (index) => setState(() => _currentIndex = index),
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                title: Center(child: Text('home', style: TextStyle(color: KSacandColor))),
                icon: Center(child: Icon(Icons.home, color: KSacandColor)),
              ),
              BottomNavyBarItem(
                title: Center(child: Text('notifications', style: TextStyle(color: KSacandColor))),
                icon: Center(child: Icon(Icons.notifications, color: KSacandColor)),
              ),
              BottomNavyBarItem(
                title: Center(child: Text(' Profile', style: TextStyle(color: KSacandColor))),
                icon: Center(child: Icon(Icons.portrait, color: KSacandColor)),
              ),
              BottomNavyBarItem(
                title: Center(child: Text('chat', style: TextStyle(color: KSacandColor))),
                icon: Center(child: Icon(Icons.chat, color: KSacandColor)),
              ),
            ],
          ),
        )
      ],
    );
  }

  // _changeHome(BuildContext context) {
  //   if (Provider.of<Admin>(context, listen: false).isAdmin) {
  //     child:
  //     AdminHome();
  //   } else {
  //     child:
  //     Home();
  //   }
  // }
}

class MYpopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      color: KSacandColor,
      onSelected: (Menu option) {
        print(option.toString());
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<Menu>>[
          PopupMenuItem(
            child: Text('Setting'),
            value: Menu.Settings,
          ),
          PopupMenuItem(
            child: Text('About'),
            value: Menu.About,
          ),
          PopupMenuItem(
            child: Text('Aboutt'),
            value: Menu.Aboutt,
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

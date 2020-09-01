/*import 'package:enactusnca/AddNewPost/upload.dart';
import 'package:enactusnca/BottomNavBar.dart';
import 'package:enactusnca/Screens/Home/Home.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'Screens/bottom_nav/home.dart';
import 'Screens/bottom_nav/notifications.dart';
import 'Screens/bottom_nav/profile.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottBar extends StatefulWidget {
  static String id = 'BottBar';

  @override
  _BottBarState createState() => _BottBarState();
}

final BottomNavBar _bottomNavBar = BottomNavBar();
final home _home = home();
final notifications _notifications = notifications();
final profile _profile = profile();
//final ChatScreen _chatScreen= ChatScreen();
//final LoginScreen  _profile = LoginScreen();
Widget _showpage = new home();

Widget _pagechoser(int page) {
  switch (page) {
    case 0:
      return Home();
    case 1:
      return _home;
    case 2:
      return _home;
    case 3:
      return _profile;
    case 4:
      return _home;
    default:
      return new Container();
  }
}

class _BottBarState extends State<BottBar> {
  int _page = 0;
  int index = 0;
  String page = 'Grey';
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Likes',
      style: optionStyle,
    ),
    Text(
      'Index 2: Search',
      style: optionStyle,
    ),
    Text(
      'Index 3: Profile',
      style: optionStyle,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        child: _pagechoser(_page),
      )
          // child: _widgetOptions.elementAt(_selectedIndex),
          ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3),
            child: GNav(
                gap: 8,
                activeColor: KSacandColor,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: KMainColor,
                tabs: [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: LineIcons.heart_o,
                    text: 'Likes',
                  ),
                  GButton(
                    icon: LineIcons.search,
                    text: 'Search',
                  ),
                  GButton(
                    icon: LineIcons.user,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}
*/

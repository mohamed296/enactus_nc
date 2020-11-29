import 'package:flutter/material.dart';

class PopUpMenu {
  //static const String calendar = 'calendar';
  static const String aboutUS = 'AboutUs';
  static const String signOut = 'SignOut';

  static const List<String> choices = <String>[
    // calendar,
    aboutUS,
    signOut,
  ];
  static const List<Icon> icons = <Icon>[
    Icon(Icons.settings),
    Icon(Icons.check_box_outline_blank),
    Icon(Icons.calendar_view_day),
    Icon(Icons.info),
  ];
}

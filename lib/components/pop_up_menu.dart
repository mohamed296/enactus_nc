import 'package:flutter/material.dart';

class PopUpMenu {
  static const String aboutUS = 'AboutUs';
  static const String signOut = 'SignOut';

  static const List<String> choices = <String>[
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

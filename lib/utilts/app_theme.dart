import 'package:enactusnca/Widgets/constants.dart';
import 'package:flutter/material.dart';

class AppTheme extends ChangeNotifier {
  ThemeData themeData;

  AppTheme({this.themeData});

  getTheme() => themeData;

  setTheme(ThemeData theme) {
    themeData = theme;
    notifyListeners();
  }

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    accentColor: kSacandColor,
    scaffoldBackgroundColor: Colors.white,
    cursorColor: Colors.amber,
    buttonColor: kSacandColor,
    brightness: Brightness.light,

    // color of floating action in light theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: kMainColor,
    ),

    // color of the icons
    iconTheme: IconThemeData(color: kMainColor),

    // appbar in light theme
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      color: kMainColor,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: kSacandColor,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(color: kSacandColor),
      actionsIconTheme: IconThemeData(color: kSacandColor),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: Color(0xff0C1E34),
    accentColor: kSacandColor,
    //scaffoldBackgroundColor: kDarkColor,
    scaffoldBackgroundColor: Color(0xff0C1E34),
    cursorColor: Colors.amber,
    buttonColor: Color(0xff0C1E34),
    brightness: Brightness.dark,

    // color of floating action in dark theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: kSacandColor,
    ),

    // color of the icons
    iconTheme: IconThemeData(color: Colors.amber),

    // appbar in dark theme
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      centerTitle: true,
      color: Color(0xff0C1E34),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(color: kSacandColor),
      actionsIconTheme: IconThemeData(color: kSacandColor),
    ),
    backgroundColor: kMainColor,
  );
}

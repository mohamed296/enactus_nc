import 'package:enactusnca/Widgets/constants.dart';
import 'package:flutter/material.dart';

class AppThemeProvider extends ChangeNotifier {
  ThemeData themeData;

  AppThemeProvider({this.themeData});

  getTheme() => themeData;

  setTheme(ThemeData theme) {
    themeData = theme;
    notifyListeners();
  }

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    accentColor: KSacandColor,
    scaffoldBackgroundColor: Colors.white,
    cursorColor: Colors.amber,
    buttonColor: KSacandColor,
    brightness: Brightness.light,

    // color of floating action in light theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: KMainColor,
    ),

    // color of the icons
    iconTheme: IconThemeData(color: KMainColor),

    // appbar in light theme
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      color: KMainColor,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: KSacandColor,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(color: KSacandColor),
      actionsIconTheme: IconThemeData(color: KSacandColor),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: Color(0xff0C1E34),
    accentColor: KSacandColor,
    //scaffoldBackgroundColor: kDarkColor,
    scaffoldBackgroundColor: Color(0xff0C1E34),
    cursorColor: Colors.amber,
    buttonColor: Color(0xff0C1E34),
    brightness: Brightness.dark,

    // color of floating action in dark theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: KSacandColor,
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
      iconTheme: IconThemeData(color: KSacandColor),
      actionsIconTheme: IconThemeData(color: KSacandColor),
    ),
    backgroundColor: KMainColor,
  );
}

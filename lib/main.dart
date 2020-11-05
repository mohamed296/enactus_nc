import 'package:enactusnca/AddNewPost/upload.dart';
import 'package:enactusnca/Admin/EditPost.dart';
import 'package:enactusnca/Events/Calendar.dart';
import 'package:enactusnca/Events/addEvent.dart';
import 'package:enactusnca/Events/view_Event.dart';
import 'package:enactusnca/Screens/Home/Home.dart';
import 'package:enactusnca/Screens/Profile/ProfilePostTile.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/Screens/views/chat.dart';
import 'package:enactusnca/Screens/views/sign_in.dart';
import 'package:enactusnca/utilts/app_theme_provider.dart';
import 'package:enactusnca/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = prefs.getString('user');
  var theme = prefs.getBool('darkTheme');
  print(user);
  runApp(
    ChangeNotifierProvider<AppThemeProvider>(
      create: (context) => AppThemeProvider(
        themeData: theme == null || theme == false
            ? AppThemeProvider.darkTheme
            : AppThemeProvider.lightTheme,
      ),
      child: MyApp(user: user),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String user;

  const MyApp({Key key, this.user}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.getTheme(),
      /**
       * initialRoute has been changed to HomeScreen if the user has
       * signed in once before.
       * */
      initialRoute: widget.user != null ? Wrapper.id : SignIn.id,
      routes: {
        SignIn.id: (context) => SignIn(),
        // LoginScreen.id: (context) => LoginScreen(),
        // SignupScreen.id: (context) => SignupScreen(),
        Wrapper.id: (context) => Wrapper(),
        AddNewPost.id: (context) => AddNewPost(),
        EditPost.id: (context) => EditPost(),
        Profile.id: (context) => Profile(),
        Chat.id: (context) => Chat(),
        Calender.id: (context) => Calender(),
        AddEventPage.id: (context) => AddEventPage(),
        EventDetailsPage.id: (context) => EventDetailsPage(),
        Home.id: (context) => Home(),
        ProfileListItem.id: (context) => ProfileListItem(),
      },
    );
  }
}

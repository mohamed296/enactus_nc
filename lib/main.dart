import 'package:enactusnca/Screens/Home/Home.dart';
import 'package:enactusnca/Screens/Profile/HelpSupport.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/Screens/chat/chat.dart';
import 'package:enactusnca/Screens/authentication/sign_in.dart';
import 'package:enactusnca/Screens/chat/messages/messages.dart';
import 'package:enactusnca/utilts/app_theme.dart';
import 'package:enactusnca/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/AddNewPost/add_new_post.dart';
import 'Screens/Events/events.dart';
import 'Screens/Profile/ProfilePostTile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = prefs.getString('user');
  print(user);
  runApp(MyApp(user: user));
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: widget.user != null ? Wrapper.id : SignIn.id,
      routes: {
        SignIn.id: (context) => SignIn(),
        Wrapper.id: (context) => Wrapper(),
        AddNewPost.id: (context) => AddNewPost(),
        Profile.id: (context) => Profile(),
        Chat.id: (context) => Chat(),
        Events.id: (context) => Events(),
        Home.id: (context) => Home(),
        ProfileListItem.id: (context) => ProfileListItem(),
        Messages.id: (context) => Messages(),
        HelpSupport.id: (context) => HelpSupport(),
      },
    );
  }
}

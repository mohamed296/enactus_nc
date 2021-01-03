import 'package:enactusnca/Screens/authentication/sign_in.dart';
import 'package:enactusnca/utilts/app_theme.dart';
import 'package:enactusnca/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = prefs.getString('user');
  runApp(MyApp(user: user));
}

class MyApp extends StatefulWidget {
  final String user;

  const MyApp({Key key, this.user}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return widget.user != null ? Wrapper() : SignIn();
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

import 'package:enactusnca/AddNewPost/upload.dart';
import 'package:enactusnca/Admin/Bott_admin.dart';
import 'package:enactusnca/Admin/EditPost.dart';
import 'package:enactusnca/BottomNavBar.dart';
import 'package:enactusnca/Events/Calendar.dart';
import 'package:enactusnca/Events/addEvent.dart';
import 'package:enactusnca/Events/view_Event.dart';
import 'package:enactusnca/Screens/Home/Home.dart';
import 'package:enactusnca/Screens/Profile/ProfilePostTile.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/Screens/views/home_screen.dart';
import 'package:enactusnca/Screens/views/sign_in.dart';
import 'package:enactusnca/utilts/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Helpers/helperfunction.dart';

//void main() => runApp(MyApp());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = prefs.getString('user');
  var theme = prefs.getBool('darkTheme');
  print(user);
  runApp(
    ChangeNotifierProvider<AppThemeProvider>(
      create: (context) => AppThemeProvider(
        themeData: theme == null || theme == false
            ? AppThemeProvider.lightTheme
            : AppThemeProvider.darkTheme,
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
  void initState() {
    getLoaggedInState();
    super.initState();
  }

  bool isUserLoggedIn;

  getLoaggedInState() async {
    await HelperFunction.getUserLoggedIn().then((value) {
      setState(() {
        isUserLoggedIn = value;
      });
    });
  }

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
      initialRoute:
          isUserLoggedIn != null ? /**/ isUserLoggedIn ? Home.id : SignIn.id /**/ : SignIn.id,
      routes: {
        SignIn.id: (context) => SignIn(),
        // LoginScreen.id: (context) => LoginScreen(),
        // SignupScreen.id: (context) => SignupScreen(),
        BottomNavBar.id: (context) => BottomNavBar(),
        BottAdmin.id: (context) => BottAdmin(),
        AddNewPost.id: (context) => AddNewPost(),
        EditPost.id: (context) => EditPost(),
        Profile.id: (context) => Profile(),
        HomeScreen.id: (context) => HomeScreen(),
        Calender.id: (context) => Calender(),
        AddEventPage.id: (context) => AddEventPage(),
        EventDetailsPage.id: (context) => EventDetailsPage(),
        Home.id: (context) => Home(),
        ProfileListItem.id: (context) => ProfileListItem(),
      },
    );
    /* return MultiProvider(
      providers: [
        ChangeNotifierProvider<Admin>(create: (context) => Admin()),
        // ChangeNotifierProvider<AddNewPost>(create: (context) => AddNewPost()),
        //  ChangeNotifierProvider<User>(create: (context) => User()),
        ChangeNotifierProvider<AppThemeProvider>(
            create: (context) => AppThemeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Enactus plus',
        theme: ThemeData(),
        // theme: ThemeProvider.of(context),
        initialRoute: BottAdmin.id,
        routes: {
          SignIn.id: (context) => SignIn(),
          // LoginScreen.id: (context) => LoginScreen(),
          // SignupScreen.id: (context) => SignupScreen(),
          BottomNavBar.id: (context) => BottomNavBar(),
          BottAdmin.id: (context) => BottAdmin(),
          AddNewPost.id: (context) => AddNewPost(),
          EditPost.id: (context) => EditPost(),
          Profile.id: (context) => Profile(),
          HomeScreen.id: (context) => HomeScreen(),
          Calender.id: (context) => Calender(),
          AddEventPage.id: (context) => AddEventPage(),
          EventDetailsPage.id: (context) => EventDetailsPage(),
          Home.id: (context) => Home(),
        },
      ),
    );*/
  }
}

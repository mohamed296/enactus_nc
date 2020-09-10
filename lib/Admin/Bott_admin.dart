import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Admin/adminhome.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Models/User.dart';
import 'package:enactusnca/Screens/Home/Home.dart';
import 'package:enactusnca/Screens/Notifications/notifications.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/Screens/bottom_nav/home.dart';
import 'package:enactusnca/Screens/views/home_screen.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/provider/Admin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//void main() => runApp(MaterialApp(home: BottAdmin()));

final StorageReference storageRef = FirebaseStorage.instance.ref();
final usersRef = Firestore.instance.collection('users');
final postsRef = Firestore.instance.collection('posts');
final commentsRef = Firestore.instance.collection('comments');
final activityFeedRef = Firestore.instance.collection('feed');
final timelineRef = Firestore.instance.collection('timeline');
final DateTime timestamp = DateTime.now();
User currentUser;

class BottAdmin extends StatefulWidget {
  static String id = 'BottAdmin';

  @override
  _BottAdminState createState() => _BottAdminState();
}

@override
class _BottAdminState extends State<BottAdmin> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _page = 0;
  int index = 0;
  int currentIndex;
  GlobalKey _bottomNavigationKey = GlobalKey();
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    getUserInfo();
  }

  getUserInfo() async {
    Constants.myEmail = await HelperFunction.getUserEmail();
    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
        /*  appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color.fromRGBO(25, 53, 93, 1.0),
          leading: Builder(
              builder: (context) => Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/images/en.png'),
                          ),
                        ),
                      ),
                    ),
                  )),

          actions: <Widget>[
            Hero(
              tag: 'Icon1',
              child: new IconButton(
                  icon: Icon(
                    FontAwesomeIcons.calendar,
                    color: Color.fromRGBO(253, 194, 35, 1.0),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.of(context).pushReplacementNamed('/ladingpage');
                    }).catchError((e) {
                      print(e);
                    });
                  }),
            ),
            Hero(
              tag: 'Icon2',
              child: new IconButton(
                  icon: Icon(
                    FontAwesomeIcons.ad,
                    color: Color.fromRGBO(253, 194, 35, 1.0),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AddNewPost.id);
                  }),
            ),
            Hero(
              tag: 'Icon3',
              child: new IconButton(
                  icon: Icon(
                    FontAwesomeIcons.edit,
                    color: Color.fromRGBO(253, 194, 35, 1.0),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, EditPost.id);
                  }),
            ),
            MYpopup(),
          ],
          // title: Text('Home',),
        ),*/
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              Container(
                //child: _changeHome(context)
                child: Home(),
              ),
              Container(
                child: notifications(),
              ),
              Container(
                child: Profile(
                  email: Constants.myEmail,
                ),
              ),
              Container(
                child: HomeScreen(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            //  BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
          ]),
          child: SafeArea(
            child: BottomNavyBar(
              animationDuration: Duration(milliseconds: 200),
              containerHeight: 40,
              iconSize: 24,
              backgroundColor: kDarkColor,
              selectedIndex: _currentIndex,
              onItemSelected: (index) {
                setState(() => _currentIndex = index);
                _pageController.jumpToPage(index);
              },
              items: <BottomNavyBarItem>[
                BottomNavyBarItem(
                    title: Center(
                      child: Text(
                        'home',
                        style: TextStyle(color: KSacandColor),
                      ),
                    ),
                    icon: Center(
                      child: Icon(
                        Icons.home,
                        color: KSacandColor,
                      ),
                    )),
                BottomNavyBarItem(
                    title: Center(
                      child: Text(
                        'notifications',
                        style: TextStyle(color: KSacandColor),
                      ),
                    ),
                    icon: Center(
                      child: Icon(
                        Icons.notifications,
                        color: KSacandColor,
                      ),
                    )),
                BottomNavyBarItem(
                    title: Center(
                      child: Text(
                        ' Profile',
                        style: TextStyle(color: KSacandColor),
                      ),
                    ),
                    icon: Center(
                      child: Icon(
                        Icons.portrait,
                        color: KSacandColor,
                      ),
                    )),
                BottomNavyBarItem(
                    title: Center(
                      child: Text(
                        'chat',
                        style: TextStyle(color: KSacandColor),
                      ),
                    ),
                    icon: Center(
                      child: Icon(
                        Icons.chat,
                        color: KSacandColor,
                      ),
                    )),
              ],
            ),
          ),
        ),
      )
    ]);
  }

  _changeHome(BuildContext context) {
    if (Provider.of<Admin>(context, listen: false).isAdmin) {
      child:
      AdminHome();
    } else {
      child:
      home();
    }
  }
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

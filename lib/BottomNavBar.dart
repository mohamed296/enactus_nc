import 'package:enactusnca/Admin/adminhome.dart';
import 'package:enactusnca/Screens/bottom_nav/home.dart';
import 'package:enactusnca/Screens/Notifications/notifications.dart';
import 'package:enactusnca/Screens/bottom_nav/profile.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/provider/Admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  static String id = 'BottomNavBar';

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

final BottomNavBar _bottomNavBar = BottomNavBar();
final Home _home = Home();
final Notifications _notifications = Notifications();
final Profile _profile = Profile();
Widget _showpage = new Home();

Widget _pagechoser(int page) {
  switch (page) {
    case 0:
      return _home;
    case 1:
      return _notifications;
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

@override
class _BottomNavBarState extends State<BottomNavBar> {
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
        appBar: AppBar(
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
              tag: 'Icon2',
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
            MYpopup(),
          ],
          // title: Text('Home',),
        ),
        /* bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: 0,
            height: 50.0,
            items: <Widget>[
              Icon(
                FontAwesomeIcons.home,
                size: 30,
                color: Color.fromRGBO(253, 194, 35, 1.0),
              ),
              Icon(
                Icons.notifications_active,
                size: 30,
                color: Color.fromRGBO(253, 194, 35, 1.0),
              ),
              //  Icon(FontAwesomeIcons.edit,size:30,color: Color.fromRGBO(253, 194, 35, 1.0),),
              Icon(
                FontAwesomeIcons.user,
                size: 30,
                color: Color.fromRGBO(253, 194, 35, 1.0),
              ),
              Icon(
                FontAwesomeIcons.facebookMessenger,
                size: 30,
                color: Color.fromRGBO(253, 194, 35, 1.0),
              ),
            ],
            color: Color.fromRGBO(25, 53, 93, 1.0),
            backgroundColor: Color.fromRGBO(25, 69, 131, 1.0),
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 400),
            onTap: (pageindex) {
              setState(() {
                _showpage = _pagechoser(pageindex);
              });
            },
          ),*/

        /*   bottomNavigationBar: BubbleBottomBar(
            hasNotch: true,
            fabLocation: BubbleBottomBarFabLocation.end,
            opacity: .2,
            currentIndex: currentIndex,
            onTap: changePage,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)), //border radius doesn't work when the notch is enabled.
            elevation: 8,
            items: <BubbleBottomBarItem>[
              BubbleBottomBarItem(
                  backgroundColor: Colors.red,
                  icon: Icon(
                    Icons.dashboard,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.dashboard,
                    color: Colors.red,
                  ),
                  title: Text("Home")),
              BubbleBottomBarItem(
                  backgroundColor: Colors.deepPurple,
                  icon: Icon(
                    Icons.access_time,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.access_time,
                    color: Colors.deepPurple,
                  ),
                  title: Text("Logs")),
              BubbleBottomBarItem(
                  backgroundColor: Colors.indigo,
                  icon: Icon(
                    Icons.folder_open,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.folder_open,
                    color: Colors.indigo,
                  ),
                  title: Text("Folders")),
              BubbleBottomBarItem(
                  backgroundColor: Colors.green,
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.menu,
                    color: Colors.green,
                  ),
                  title: Text("Menu"))
            ],
          ),*/
        /*body: Container(
            child: _showpage,
          )),*/
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
                child: Notifications(),
              ),
              Container(
                child: Profile(),
              ),
              Container(
                color: Colors.blue,
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: KMainColor,
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                title: Text(
                  'home',
                  style: TextStyle(color: KSacandColor),
                ),
                icon: Icon(
                  Icons.home,
                  color: KSacandColor,
                )),
            BottomNavyBarItem(
                title: Text(
                  'notifications',
                  style: TextStyle(color: KSacandColor),
                ),
                icon: Icon(
                  Icons.notifications,
                  color: KSacandColor,
                )),
            BottomNavyBarItem(
                title: Text(
                  ' Profile',
                  style: TextStyle(color: KSacandColor),
                ),
                icon: Icon(
                  Icons.portrait,
                  color: KSacandColor,
                )),
            BottomNavyBarItem(
                title: Text(
                  'chat',
                  style: TextStyle(color: KSacandColor),
                ),
                icon: Icon(
                  Icons.chat,
                  color: KSacandColor,
                )),
          ],
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
      Home();
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

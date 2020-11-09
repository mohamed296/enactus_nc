import 'package:enactusnca/Screens/AddNewPost/add_new_post.dart';
import 'package:enactusnca/Screens/Events/Calendar.dart';
import 'package:enactusnca/Screens/Home/PostsList.dart';
import 'package:enactusnca/Screens/Settings/Settings.dart';
import 'package:enactusnca/Widgets/PopUpMenu.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static String id = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController scrollController = ScrollController();
  Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          // backgroundColor: KMainColor,
          child: Icon(
            Icons.add,
            // color: KSacandColor,
          ),
          onPressed: () => Navigator.pushNamed(context, AddNewPost.id)),
      /* appBar: AppBar(
        elevation: 0.0,
        title: Text('Discovery'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: select,
            itemBuilder: (context) {
              return PopUpMenu.choices.map((String choice) {
                return PopupMenuItem(
                  child: Text(choice),
                  value: choice,
                );
              }).toList();
            },
          ),
        ],
      ),*/
      appBar: AppBar(
        //elevation: 5.0,
        //   backgroundColor: Color.fromRGBO(25, 53, 93, 1.0),
        leading: Builder(
            builder: (context) => Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: InkWell(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                            'assets/images/enplus.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                )),

        actions: <Widget>[
          /*    Hero(
            tag: 'Icon1',
            child: new IconButton(
                icon: Icon(
                  LineAwesomeIcons.calendar,
                  color: Color.fromRGBO(253, 194, 35, 1.0),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Calender.id);
                }),
          ),*/

          /*  Hero(
            tag: 'Icon3',
            child: new IconButton(
                icon: Icon(
                  FontAwesomeIcons.edit,
                  color: Color.fromRGBO(253, 194, 35, 1.0),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, EditPost.id);
                }),
          ),*/
          PopupMenuButton(
            onSelected: select,
            itemBuilder: (context) {
              return PopUpMenu.choices.map((String choice) {
                return PopupMenuItem(
                  child: Text(choice),
                  value: choice,
                );
              }).toList();
            },
          ),
        ],

        // title: Text('Home',),
      ),
      body: PostsList(),
    );
  }

  void select(String choice) {
    if (choice == PopUpMenu.settings) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Settings(),
        ),
      );
    } else if (choice == PopUpMenu.signOut) {
      //  auth.signOutGoogle(context);
    } else if (choice == PopUpMenu.calendar) {
      Navigator.pushNamed(context, Calender.id);
    } else if (choice == PopUpMenu.aboutUS) {
      // Navigator.pushNamed(context, Calender.id);
    }
  }
}

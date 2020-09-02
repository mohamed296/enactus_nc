import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:enactusnca/Events/Calendar.dart';
import 'package:enactusnca/Models/NewPost.dart';
import 'package:enactusnca/Models/User.dart';
import 'package:enactusnca/Screens/Profile/ProfilePostTile.dart';
import 'package:enactusnca/Screens/views/sign_in.dart';
import 'package:enactusnca/Settings/Settings.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/halper/helperfunction.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatefulWidget {
  static String id = 'Profile';
  final String postUserId;
  final String username;
  final Post post;
  Profile({this.postUserId, this.username, this.post});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ScrollController controller = ScrollController();
  Auth authMethods = new Auth();
  User user = User();
  final users = UserTitle();
  final post = Post();
  bool favorito = false;
  bool expandText = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              height: kSpacingUnit.w * 10,
              width: kSpacingUnit.w * 10,
              margin: EdgeInsets.only(top: kSpacingUnit.w * 10),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: kSpacingUnit.w * 5,
                    backgroundImage: AssetImage('assets/images/greg.jpg'),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: kSpacingUnit.w * 2.5,
                      width: kSpacingUnit.w * 2.5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        heightFactor: kSpacingUnit.w * 1.5,
                        widthFactor: kSpacingUnit.w * 1.5,
                        child: Icon(
                          LineAwesomeIcons.pen,
                          color: kDarkPrimaryColor,
                          size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          Text(
            // post.timeStamp,
            'Setos',
            style: kTitleTextStyle,
          ),
          SizedBox(height: kSpacingUnit.w * 0.5),
          Text(
            'Shetos@gmail.com',
            style: kCaptionTextStyle,
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          Container(
            height: kSpacingUnit.w * 4,
            width: kSpacingUnit.w * 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
              color: Theme.of(context).accentColor,
            ),
            child: Center(
              child: Text(
                'Edit Profile',
                style: kButtonTextStyle,
              ),
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 5),
          Expanded(
            child: ListView(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Calender.id);
                  },
                  child: ProfileListItem(
                    icon: LineAwesomeIcons.user_shield,
                    text: 'Privacy',
                  ),
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.history,
                  text: 'Purchase History',
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.question_circle,
                  text: 'Help & Support',
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.cog,
                  text: 'Settings',
                ),
                GestureDetector(
                  onTap: () {
                    authMethods.signOut();
                    HelperFunction.setUserLoggedIn(false);
                    HelperFunction.setUsername("");
                    HelperFunction.setUserEmail("");
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignIn()));
                  },
                  child: ProfileListItem(
                    icon: LineAwesomeIcons.alternate_sign_out,
                    text: 'Logout',
                    hasNavigation: false,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

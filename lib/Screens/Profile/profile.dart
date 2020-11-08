import 'package:enactusnca/Events/Calendar.dart';
import 'package:enactusnca/Models/post.dart';
import 'package:enactusnca/Screens/Profile/ProfilePostTile.dart';
import 'package:enactusnca/Screens/Profile/edit_profile_screen.dart';
import 'package:enactusnca/Screens/authentication/sign_in.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Profile extends StatefulWidget {
  static String id = 'Profile';
  final String postUserId;
  final String username;
  final String email;
  final Post post;

  Profile({this.postUserId, this.username, this.post, this.email});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;
  ScrollController controller = ScrollController();
  String name, email;
  String firstName, lastName;
  Auth authMethods = Auth();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                      backgroundImage: NetworkImage(
                        user?.photoURL ??
                            'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                      ),
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
            Text(user.displayName, style: kTitleTextStyle),
            SizedBox(height: kSpacingUnit.w * 0.5),
            Text(user.email, style: kCaptionTextStyle),
            SizedBox(height: kSpacingUnit.w * 2),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilScreen(),
                  ),
                );
              },
              child: Container(
                height: kSpacingUnit.w * 4,
                width: kSpacingUnit.w * 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
                  color: Theme.of(context).accentColor,
                ),
                child: Center(
                  child: Text('Edit Profile', style: kButtonTextStyle),
                ),
              ),
            ),
            SizedBox(height: kSpacingUnit.w * 5),
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
              child: ProfileListItem(
                icon: LineAwesomeIcons.alternate_sign_out,
                text: 'Logout',
                hasNavigation: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}

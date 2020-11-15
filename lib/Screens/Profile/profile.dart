import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Models/post.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/Screens/Events/Calendar.dart';
import 'package:enactusnca/Screens/Profile/HelpSupport.dart';
import 'package:enactusnca/Screens/Profile/ProfilePostTile.dart';
import 'package:enactusnca/Screens/Profile/edit_profile_screen.dart';
import 'package:enactusnca/Screens/authentication/sign_in.dart';
import 'package:enactusnca/Screens/chat/messages/messages.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:enactusnca/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Profile extends StatefulWidget {
  static String id = 'Profile';
  final String postUserId;
  final String username;
  final String email;
  final String userId;
  final Post post;

  Profile({this.postUserId, this.username, this.userId, this.post, this.email});

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
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    Constants.myEmail = await HelperFunction.getUserEmail();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);

    return StreamBuilder<UserModel>(
        stream: widget.userId != null
            ? FirebaseFirestore.instance
                .collection("Users")
                .doc(widget.userId)
                .snapshots(includeMetadataChanges: false)
                .map(UserServices().userData)
            : FirebaseFirestore.instance
                .collection("Users")
                .doc(user.uid)
                .snapshots(includeMetadataChanges: false)
                .map(UserServices().userData),
        builder: (context, snapshot) {
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
                              backgroundImage:
                                  NetworkImage(snapshot.data.photoUrl)),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: snapshot.data.email == user.email
                                ? Container(
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
                                        size: ScreenUtil()
                                            .setSp(kSpacingUnit.w * 1.5),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: kSpacingUnit.w * 2),
                  Text('${snapshot.data.firstName} ${snapshot.data.lastName}',
                      style: kTitleTextStyle),
                  SizedBox(height: kSpacingUnit.w * 0.5),
                  Text(snapshot.data.email, style: kCaptionTextStyle),
                  SizedBox(height: kSpacingUnit.w * 2),
                  GestureDetector(
                    onTap: () {
                      if (snapshot.data.email == user.email) {
                        UserModel userModel = UserModel(
                          id: snapshot.data.id,
                          firstName: snapshot.data.firstName,
                          lastName: snapshot.data.lastName,
                          photoUrl: snapshot.data.photoUrl,
                          email: snapshot.data.email,
                          community: snapshot.data.community,
                          department: snapshot.data.department,
                          joiningDate: snapshot.data.joiningDate,
                          username: snapshot.data.username,
                          isActive: snapshot.data.isActive,
                          isHead: snapshot.data.isHead,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditProfilScreen(userModel: userModel)),
                        );
                      } else {
                        String roomId = createChatRoomId(
                            snapshot.data.email.toLowerCase(),
                            user.email.toLowerCase());
                        DatabaseMethods()
                            .getChatRooByRoomId(roomId: roomId)
                            .then((value) {
                          QuerySnapshot roomSnapShoot = value;
                          if (roomSnapShoot.docs.isEmpty) {
                            print('creating a room');
                            List<String> users = [
                              '${snapshot.data.firstName} ${snapshot.data.lastName}',
                              user.displayName
                            ];
                            List<String> emails = [
                              snapshot.data.email.toLowerCase(),
                              user.email.toLowerCase()
                            ];
                            Map<String, dynamic> chatRoomMap = {
                              "users": users,
                              "emails": emails,
                              "lastMessage": "",
                              "isRead": false,
                              "lastTime": null,
                              "chatroomid": roomId,
                            };
                            DatabaseMethods()
                                .createChatRoom(roomId, chatRoomMap)
                                .then((val) {
                              print('room created');
                              navigateToMessagesScreen(
                                  context: context,
                                  roomId: roomId,
                                  snapshot: snapshot,
                                  roomSnapShoot: roomSnapShoot);
                            });
                          } else {
                            print("the room exists");
                            navigateToMessagesScreen(
                                context: context,
                                roomId: roomId,
                                snapshot: snapshot,
                                roomSnapShoot: roomSnapShoot);
                          }
                        });
                      }
                    },
                    child: Container(
                      height: kSpacingUnit.w * 4,
                      width: kSpacingUnit.w * 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
                        color: Theme.of(context).accentColor,
                      ),
                      child: Center(
                        child: Text(
                            snapshot.data.email == Constants.myEmail
                                ? 'Edit Profile'
                                : 'Send a message',
                            style: kButtonTextStyle),
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
                      text: 'Calender',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HelpSupport(),
                        ),
                      );
                    },
                    child: ProfileListItem(
                      icon: LineAwesomeIcons.question_circle,
                      text: 'Help & Support',
                    ),
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
        });
  }
}

navigateToMessagesScreen(
    {BuildContext context,
    String roomId,
    snapshot,
    QuerySnapshot roomSnapShoot}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Messages(
        group: false,
        chatRoomId: roomId,
        imageUrl: snapshot.data.photoUrl,
        lastSender: roomSnapShoot.docs.isEmpty
            ? null
            : roomSnapShoot.docs[0].data()['lastSender'],
        username: '${snapshot.data.firstName} ${snapshot.data.lastName}',
      ),
    ),
  );
}

createChatRoomId(String a, String b) {
  if (a.length > b.length)
    return "$b\_$a";
  else
    return "$a\_$b";
}

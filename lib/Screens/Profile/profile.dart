import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusnca/helpers/helperfunction.dart';
import 'package:enactusnca/models/user_model.dart';
import 'package:enactusnca/services/auth.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:enactusnca/services/user_services.dart';
import 'package:enactusnca/widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:enactusnca/helpers/constants.dart';
import 'package:enactusnca/models/post.dart';
import 'package:enactusnca/screens/authentication/sign_in.dart';
import 'package:enactusnca/screens/chat/messages/messages.dart';
import 'package:enactusnca/screens/events/events.dart';

import '../../wrapper.dart';
import 'edit_profile_screen.dart';
import 'help_support.dart';
import 'profile_post_tile.dart';

class Profile extends StatefulWidget {
  final String postUserId;
  final bool isAppBarEnabled;
  final String username;
  final String email;
  final String userId;
  final Post post;

  const Profile({
    Key key,
    this.postUserId,
    this.isAppBarEnabled,
    this.username,
    this.email,
    this.userId,
    this.post,
  }) : super(key: key);

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
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    Constants.myEmail = await HelperFunction.getUserEmail();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.amber),
        leading: widget.isAppBarEnabled
            ? GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Wrapper()),
                ),
                child: const Icon(Icons.arrow_back),
              )
            : Container(),
      ),
      body: StreamBuilder<UserModel>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(widget.userId ?? user.uid)
            .snapshots()
            .map(UserServices().userData),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: kSpacingUnit.w * 5 as double,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              kSpacingUnit.w * 5 as double),
                          child: (snapshot?.data?.photoUrl != null)
                              ? Image.network(snapshot.data.photoUrl)
                              : Image.asset('assets/images/enactus.png'),
                        ),
                      ),
                      SizedBox(height: kSpacingUnit.w * 2 as double),
                      Text(
                        '${snapshot?.data?.firstName} ${snapshot?.data?.lastName}',
                        style: kTitleTextStyle,
                      ),
                      SizedBox(height: kSpacingUnit.w * 0.5 as double),
                      Text(snapshot?.data?.email, style: kCaptionTextStyle),
                      SizedBox(height: kSpacingUnit.w * 0.5 as double),
                      Text(snapshot?.data?.community, style: kCaptionTextStyle),
                      SizedBox(height: kSpacingUnit.w * 2 as double),
                      GestureDetector(
                        onTap: () {
                          if (snapshot?.data?.email == user.email) {
                            final UserModel userModel = UserModel(
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
                                    EditProfilScreen(userModel: userModel),
                              ),
                            );
                          } else {
                            final String roomId = createChatRoomId(
                              snapshot.data.email.toLowerCase(),
                              user.email.toLowerCase(),
                            );
                            DatabaseMethods()
                                .getChatRooByRoomId(roomId: roomId)
                                .then(
                              (value) {
                                final QuerySnapshot roomSnapShoot = value;
                                if (roomSnapShoot.docs.isEmpty) {
                                  final List<String> ids = [
                                    snapshot.data.id,
                                    user.uid
                                  ];
                                  final List<String> users = [
                                    '${snapshot.data.firstName} ${snapshot.data.lastName}',
                                    user.displayName
                                  ];
                                  final List<String> emails = [
                                    snapshot.data.email.toLowerCase(),
                                    user.email.toLowerCase()
                                  ];
                                  final Map<String, dynamic> chatRoomMap = {
                                    "users": users,
                                    "emails": emails,
                                    'ids': ids,
                                    "lastMessage": "",
                                    "isRead": false,
                                    "lastTime": null,
                                    "chatroomid": roomId,
                                  };
                                  DatabaseMethods()
                                      .createChatRoom(roomId, chatRoomMap)
                                      .then((val) {
                                    navigateToMessagesScreen(
                                        context: context,
                                        roomId: roomId,
                                        snapshot: snapshot,
                                        roomSnapShoot: roomSnapShoot);
                                  });
                                } else {
                                  navigateToMessagesScreen(
                                    context: context,
                                    roomId: roomId,
                                    snapshot: snapshot,
                                    roomSnapShoot: roomSnapShoot,
                                  );
                                }
                              },
                            );
                          }
                        },
                        child: Container(
                          height: kSpacingUnit.w * 4 as double,
                          width: kSpacingUnit.w * 20 as double,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                kSpacingUnit.w * 3 as double),
                            color: Theme.of(context).accentColor,
                          ),
                          child: Center(
                            child: Text(
                              snapshot.data.email == Constants.myEmail
                                  ? 'Edit Profile'
                                  : 'Send a message',
                              style: kButtonTextStyle,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: kSpacingUnit.w * 5 as double),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Events()),
                          );
                        },
                        child: const ProfileListItem(
                          icon: LineAwesomeIcons.calendar,
                          text: 'Events',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpSupport()),
                          );
                        },
                        child: const ProfileListItem(
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
                        child: const ProfileListItem(
                          icon: LineAwesomeIcons.alternate_sign_out,
                          text: 'Logout',
                          hasNavigation: false,
                        ),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}

void navigateToMessagesScreen({
  BuildContext context,
  String roomId,
  snapshot,
  QuerySnapshot roomSnapShoot,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Messages(
        group: false,
        chatRoomId: roomId,
        imageUrl: snapshot.data.photoUrl as String,
        userId: snapshot.data.id as String,
        lastSender: roomSnapShoot.docs.isEmpty
            ? null
            : roomSnapShoot.docs[0].data()['lastSender'] as String,
        username: '${snapshot.data.firstName} ${snapshot.data.lastName}',
      ),
    ),
  );
}

String createChatRoomId(String a, String b) {
  if (a.length > b.length) {
    return '$b _ $a';
  } else {
    return "$a _ $b";
  }
}

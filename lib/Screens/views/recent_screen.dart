import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Widgets/favorite_contacts.dart';
import 'package:enactusnca/Widgets/recent_chats.dart';
import 'package:flutter/material.dart';

class RecentScreen extends StatefulWidget {
  @override
  _RecentScreenState createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    Constants.myEmail = await HelperFunction.getUserEmail();
    Constants.myId = await HelperFunction.getUserId();
    Constants.myName = await HelperFunction.getUsername();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isLoading
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          topLeft: Radius.circular(30)),
                      //   color: Constants.darkBlue,
                    ),
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          child: FavoriteContacts(),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30)),
                        ),
                        RecentChat(),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}

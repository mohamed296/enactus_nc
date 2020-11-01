import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  Stream contactsStream;
  bool isLoadingOver = false;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUsername();
    Constants.myEmail = await HelperFunction.getUserEmail();
    Constants.myId = await HelperFunction.getUserId();
    databaseMethods.getUsers().then((val) {
      setState(() {
        contactsStream = val;
      });
    });
    setState(() {
      isLoadingOver = true;
    });
  }

  Widget createChatContacts() {
    return StreamBuilder(
        stream: contactsStream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Center(
                child: Text(
                  'poor internet connection\nIt seems like you\'re one of WE clients',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                ),
              );
              break;
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;
            default:
              return snapshot.hasData
                  ? buildList(snapshot)
                  : Center(
                      child: Center(
                        child: Container(),
                      ),
                    );
              break;
          }
        });
  }

  Widget buildList(snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.documents.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: singleUser(
              context: context,
              name: snapshot.data.documents[index].data()['name'],
              emali: snapshot.data.documents[index].data()['email'],
              imageURL: snapshot.data.documents[index].data()['photoURL']),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return createChatContacts();
  }
}

Widget singleUser({String name, String imageURL, String emali, BuildContext context}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(
                    email: emali,
                  )));
    },
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 20.0,
            right: 20.0,
          ),
          child: CircleAvatar(
            radius: 35,
            backgroundImage:
                imageURL != null ? AssetImage("assets/images/sam.jpg") : NetworkImage(imageURL),
          ),
        ),
        Text(
          name,
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ],
    ),
  );
}

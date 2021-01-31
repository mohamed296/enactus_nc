import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Members extends StatefulWidget {
  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  Stream contactsStream;
  bool isLoadingOver = false;
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future getUserInfo() async {
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
              return const Center(
                child: Text(
                  "poor internet connection\nIt seems like you're one of WE clients",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                ),
              );
              break;
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
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
      itemCount: snapshot.data.documents.length as int,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(
                  isAppBarEnabled: true,
                  userId:
                      snapshot.data.documents[index].data()['uid'].toString(),
                ),
              ),
            );
          },
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        snapshot.data.documents[index].data()['photoUrl'] ==
                                null
                            ? const AssetImage("assets/images/person.png")
                            : NetworkImage(snapshot.data.documents[index]
                                .data()['photoUrl']
                                .toString()),
                  ),
                ),
                Text(
                  '${snapshot.data.documents[index].data()['firstName']} ${snapshot.data.documents[index].data()['lastName']}',
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return createChatContacts();
  }
}

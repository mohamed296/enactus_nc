import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/services/database_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Members extends StatefulWidget {
  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  Stream<List<UserModel>> contactsStream;
  bool isLoadingOver = false;
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future getUserInfo() async {
    databaseMethods.getUsers().then((val) {
      setState(() => contactsStream = val as Stream<List<UserModel>>);
    });
    setState(() => isLoadingOver = true);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: contactsStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? buildList(snapshot) : const CircularProgressIndicator();
      },
    );
  }

  Widget buildList(AsyncSnapshot<List<UserModel>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
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
                  userId: snapshot.data[index].id,
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
                    backgroundImage: snapshot.data[index].photoUrl == null
                        ? const AssetImage("assets/images/person.png") as ImageProvider
                        : NetworkImage(snapshot.data[index].photoUrl),
                  ),
                ),
                Text(
                  '${snapshot.data[index].firstName} ${snapshot.data[index].lastName}',
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

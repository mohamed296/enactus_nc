import 'package:enactusnca/Helpers/helperfunction.dart';
import 'package:enactusnca/Models/user_model.dart';
import 'package:enactusnca/services/message_group_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database_methods.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithEmail({String email, String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (ex) {
      print("sing in issue ${ex.toString()}");
    }
  }

  Future signUpWithEmail(UserModel userModel, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: password,
      );
      await result.user.updateProfile(
        displayName: '${userModel.firstName} ${userModel.lastName}',
        photoURL: userModel.photoUrl,
      );
      User firebaseUser = result.user;
      await DatabaseMethods()
          .uploadUserInfo(userModel: userModel, uid: firebaseUser.uid)
          .then((value) {
        MessageGroupServices()
            .createGroupChatOrAddNewMember(userModel.community, userModel);
        if (userModel.department != null) {
          MessageGroupServices()
              .createGroupChatOrAddNewMember(userModel.department, userModel);
        }
        MessageGroupServices()
            .createGroupChatOrAddNewMember('Enactus NC', userModel);
      });
      sharedPreferences.setString('user', userModel.email);
      HelperFunction.setUserEmail(userModel.email);
      HelperFunction.setUsername(
          '${userModel.firstName} ${userModel.lastName}');

      return firebaseUser;
    } catch (ex) {
      print("sing up issue ${ex.toString()}");
    }
  }

  Future resatPassword({String email}) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (ex) {
      print("resat Password issue ${ex.toString()}");
    }
  }

  Future signOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      return await _auth
          .signOut()
          .whenComplete(() => sharedPreferences.remove('user'));
    } catch (ex) {
      print("Signing out issue ${ex.toString()}");
    }
  }
}

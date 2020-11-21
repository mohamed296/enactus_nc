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
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
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
      final User firebaseUser = result.user;
      final UserModel authUser = UserModel(
        id: firebaseUser.uid,
        firstName: userModel.firstName,
        lastName: userModel.lastName,
        photoUrl: userModel.photoUrl,
        email: userModel.email,
        community: userModel.community,
        department: userModel.department,
        joiningDate: userModel.joiningDate,
        username: userModel.username,
        isActive: userModel.isActive,
        isHead: userModel.isHead,
      );
      await DatabaseMethods()
          .uploadUserInfo(userModel: authUser, uid: firebaseUser.uid)
          .then((value) {
        MessageGroupServices().createGroupChatOrAddNewMember(authUser.community, authUser);
        if (userModel.department != null) {
          MessageGroupServices().createGroupChatOrAddNewMember(authUser.department, authUser);
        }
        MessageGroupServices().createGroupChatOrAddNewMember('Enactus NC', authUser);
      });
      sharedPreferences.setString('user', authUser.email);
      HelperFunction.setUserEmail(authUser.email);
      HelperFunction.setUsername('${authUser.firstName} ${authUser.lastName}');

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
      return await _auth.signOut().whenComplete(() => sharedPreferences.remove('user'));
    } catch (ex) {
      print("Signing out issue ${ex.toString()}");
    }
  }
}

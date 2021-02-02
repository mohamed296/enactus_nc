import 'package:enactusnca/constant/helperfunction.dart' as helper_functions;
import 'package:enactusnca/model/user_model.dart';
import 'package:enactusnca/services/message_group_services.dart';
import 'package:enactusnca/services/notification_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database_methods.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signInWithEmail({String email, String password}) async {
    try {
      final UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User user = result.user;
      final String id = user.uid;
      NotificationManager().getAndSaveToken(id);
      return DatabaseMethods().checkUserActivate(id);
    } catch (ex) {
      return ex.toString();
    }
  }

  Future signInWithPhoneNumber({String phoneNumber}) async {
    try {
      final ConfirmationResult result = await _auth.signInWithPhoneNumber(phoneNumber);
      final user = result;
      return user;
    } catch (ex) {
      return ex.toString();
    }
  }

  Future<String> signUpWithEmail(UserModel userModel, String password) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
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
        isActive: false,
        isHead: false,
        isAdmin: false,
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
      helper_functions.setUserEmail(authUser.email);
      helper_functions.setUsername('${authUser.firstName} ${authUser.lastName}');
      NotificationManager().getAndSaveToken(firebaseUser.uid);

      return 'success';
    } catch (ex) {
      return ex.toString();
    }
  }

  Future resatPassword({String email}) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (ex) {
      // ignore: avoid_print
      print("resat Password issue ${ex.toString()}");
    }
  }

  Future signOut() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      return await _auth.signOut().whenComplete(() => sharedPreferences.remove('user'));
    } catch (ex) {
      // ignore: avoid_print
      print("Signing out issue ${ex.toString()}");
    }
  }
}

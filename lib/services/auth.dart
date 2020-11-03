import 'package:enactusnca/Models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserTitle _userFromFirebase(FirebaseUser user) {
    return user != null ? UserTitle(userId: user.uid) : null;
  }

  Future signInWithEmail({String email, String password}) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    } catch (ex) {
      print("sing in issue ${ex.toString()}");
    }
  }

  Future signUpWithEmail({String email, String password}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebase(firebaseUser);
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
    try {
      return await _auth.signOut();
    } catch (ex) {
      print("Signing out issue ${ex.toString()}");
    }
  }
}

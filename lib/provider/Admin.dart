import 'package:flutter/cupertino.dart';

class Admin extends ChangeNotifier {
  bool isAdmin = false;
  changeIsAdmin(bool value) {
    isAdmin = value;
    notifyListeners();
  }
}

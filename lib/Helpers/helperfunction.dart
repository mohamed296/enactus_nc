import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";

  static String sharedPreferenceUsernameKey = "USERNAMEKEY";

  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  static String sharedPreferenceUserId = "USEREID";

  static String sharedPreferenceUserDepartment = "USEREDEPARTMENT";

  static Future<bool> getUserLoggedIn() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<bool> setUserLoggedIn(bool isUserLoggedIn) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> setUserId(String userId) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(sharedPreferenceUserId, userId);
  }

  static Future<String> getUserId() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserId);
  }

  static Future<bool> setUsername(String username) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(sharedPreferenceUsernameKey, username);
  }

  static Future<String> getUsername() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUsernameKey);
  }

  static Future<bool> setUserEmail(String userEmail) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<String> getUserEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserEmailKey);
  }

  static Future<bool> setUserDepartment(String userDepartment) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(
        sharedPreferenceUserDepartment, userDepartment);
  }

  static Future<String> getUserDepartment() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserDepartment);
  }
}

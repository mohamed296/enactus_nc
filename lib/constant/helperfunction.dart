import 'package:shared_preferences/shared_preferences.dart';

String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";

String sharedPreferenceUsernameKey = "USERNAMEKEY";

String sharedPreferenceUserEmailKey = "USEREMAILKEY";

String sharedPreferenceUserId = "USEREID";

String sharedPreferenceUserDepartment = "USEREDEPARTMENT";

Future<bool> getUserLoggedIn() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool(sharedPreferenceUserLoggedInKey);
}

Future<bool> setUserLoggedIn({bool isUserLoggedIn}) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
}

Future<bool> setUserId(String userId) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.setString(sharedPreferenceUserId, userId);
}

Future<String> getUserId() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString(sharedPreferenceUserId);
}

Future<bool> setUsername(String username) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.setString(sharedPreferenceUsernameKey, username);
}

Future<String> getUsername() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString(sharedPreferenceUsernameKey);
}

Future<bool> setUserEmail(String userEmail) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.setString(sharedPreferenceUserEmailKey, userEmail);
}

Future<String> getUserEmail() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString(sharedPreferenceUserEmailKey);
}

Future<bool> setUserDepartment(String userDepartment) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.setString(sharedPreferenceUserDepartment, userDepartment);
}

Future<String> getUserDepartment() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString(sharedPreferenceUserDepartment);
}

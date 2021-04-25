import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavePassConfig {
  static const String appName = "ذخیره پسورد تیک";

  static SharedPreferences sharedPreferences;
  static FirebaseAuth auth;
  // static FirebaseUser User;

  //static Firestore firestore;

  static final String userName = "userName";
  static final String userEmail = "userEmail";
  static final String userAvatar = "userAvatar";
  static final String userId = "userId";

  static Future savaUser() async =>
      sharedPreferences ??= await SharedPreferences.getInstance();

  static Future setUserName(String setuserName) async =>
      await sharedPreferences.setString(userName, setuserName);

  static Future getUserName(String getuserName) async =>
      sharedPreferences.getString(userName);

  static Future setEmail(String setEmail) async =>
      await sharedPreferences.setString(userEmail, setEmail);

  static Future getEmail(String getEmail) async =>
      sharedPreferences.getString(userEmail);

  static Future setUserAvatar(String setUserAvatar) async =>
      await sharedPreferences.setString(userAvatar, setUserAvatar);

  static Future getUserAvatar(String getUserAvatar) async =>
      sharedPreferences.getString(userAvatar);

  static Future setUserId(String setuserId) async =>
      await sharedPreferences.setString(userName, setuserId);

  static Future getUserId(String getUserId) async =>
      sharedPreferences.getString(userId);
}

import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  FirebaseAuth authuser = FirebaseAuth.instance;
  UserService({this.authuser});

  //regestri with email and password

  // ignore: missing_return
  Future<User> regestriUser(String email, String password) async {
    try {
      var user = await authuser.createUserWithEmailAndPassword(
          email: email, password: password);
      return user.user;
    } catch (e) {
      print(e.toString());
    }
  }

  // ignore: missing_return
  Future<User> loginUser(String email, String password) async {
    try {
      var user = await authuser.signInWithEmailAndPassword(
          email: email, password: password);
      return user.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> singOut() async {
    await authuser.signOut();
  }

  Future<bool> isSignIn() async {
    var currentUser =  authuser.currentUser;
    return currentUser != null;
  }

  Future<User> getCurrentUser() async {
    return  authuser.currentUser;
  }
}

import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:saved_pass/dailog_box/loading_dialog.dart';
import 'package:saved_pass/screens/reset_password.dart';
import 'package:saved_pass/sideMenu/drawer.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //UserService _loginuser = UserService();
  final _auth = FirebaseAuth.instance;
  TextEditingController emailcont = TextEditingController();
  TextEditingController passcont = TextEditingController();
  String userId = "";
  String msg = "";
  void showTostMassege() {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.blue[100],
        textColor: Colors.grey[700],
        fontSize: 20.0);
  }

  @override
  Widget build(BuildContext context) {
    var wi = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: he,
        width: wi,
        decoration: BoxDecoration(
          color: Color(0xffeff3f6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: he * 0.015,
            ),
            textField(he, wi, emailcont, TextInputType.emailAddress, false,
                "   ایمیل", 50, Icons.email),
            SizedBox(
              height: he * 0.05,
            ),
            textField(he, wi, passcont, TextInputType.text, true, "   رمز عبور",
                50, Icons.lock_open),
            SizedBox(
              height: he * 0.07,
            ),
            GestureDetector(
              onTap: () async {
                if (await CheckVpnConnection.isVpnActive()) {
                  if (emailcont.text.isEmpty || passcont.text.isEmpty) {
                    msg = "اطلاعات خواسته شده را پر نمایید";
                    showTostMassege();
                    return null;
                  }
                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(emailcont.text);
                  if (!emailValid) {
                    msg = "ایمیل وارد شده معتبر نمیباشد";
                    showTostMassege();
                    return null;
                  }

                  try {
                    showDialog(
                        context: context,
                        builder: (c) {
                          return LoadingDialog(
                            message: "در حال بررسی اطلاعات",
                          );
                        });

                    User loginUser;
                    final userCredential =
                        await _auth.signInWithEmailAndPassword(
                            email: emailcont.text.trim(),
                            password: passcont.text.trim());
                    loginUser = userCredential.user;
                    if (loginUser != null) {
                      readDate(loginUser).then((c) {
                        msg = "از بازگشت دوباره شما خوشحالیم!!!!";
                        showTostMassege();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (c) => HomePAge()));
                      });
                    } else {
                      msg = "کاربر مورد نظر یافت نشد!!!!";
                      showTostMassege();
                      Navigator.pop(context);
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      msg = "ایمیل وارد شده پیدا نشد";
                      showTostMassege();
                      Navigator.pop(context);
                    } else if (e.code == 'wrong-password') {
                      msg = "رمز عبور وارد شده اشتباه است";
                      showTostMassege();
                      Navigator.pop(context);
                    } else if (e.code == "user-disabled") {
                      msg =
                          "کاربر مورد نظر مسدود شده \n جهت دریافت اطلاعات بیشتر با مدیر تماس بگیرید";
                      showTostMassege();
                      Navigator.pop(context);
                    } else {
                      msg = "خطایی ناشناس رخ داده \n لطفا دوباره امتحان کنید";
                      showTostMassege();
                      Navigator.pop(context);
                    }
                  }
                } else {
                  msg =
                      " از برنامه خارج شده \n فیلتر شکن رو روشن نمایید \n دوباره وارد برنامه شوید ";
                  return showTostMassege();
                }
              },
              child: Container(
                height: he * 0.1,
                width: wi * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(wi * 0.03),
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[500],
                        offset: Offset(4, 4),
                        blurRadius: 15,
                        spreadRadius: 1),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4, -4),
                        blurRadius: 15,
                        spreadRadius: 1),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey[100],
                      Colors.grey[200],
                      Colors.grey[300],
                      Colors.grey[400]
                    ],
                    stops: [.1, .3, .8, .9],
                  ),
                ),
                child: Icon(
                  Icons.login_outlined,
                  size: wi * 0.09,
                  color: Colors.blue[200],
                ),
              ),
            ),
            SizedBox(
              height: he * 0.03,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => ResetPasswordScreen()));
                },
                child: Text("ایمیل خود را فراموش کرده ام؟؟"))
          ],
        ),
      ),
    );
  }

  Future readDate(User logUser) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(logUser.uid)
        .get();
    print("userid =");
    print(userData['uid']);
    await pref.clear();
    await pref.setString('userid', userData['uid']);
    await pref.setString('useremail', userData['emailUser']);
    await pref.setString('useravatar', userData['urlImage']);
    await pref.setString('username', userData['name']);
    await pref.setString('phone', userData['phone']);
  }

  Container textField(double he, double wi, controller, inputtype, ispass,
      hinttext, int max, IconData icon) {
    return Container(
      height: he * 0.08,
      width: wi * 0.7,
      decoration: BoxDecoration(
        color: Color(0xffef3f6),
        borderRadius: BorderRadius.circular(wi * 0.04),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, .1),
              blurRadius: 6,
              offset: Offset(6, 2),
              spreadRadius: 3),
          BoxShadow(
              color: Color.fromRGBO(255, 255, 255, .9),
              blurRadius: 3,
              offset: Offset(-6, -2),
              spreadRadius: 5)
        ],
      ),
      child: TextField(
        maxLength: max,
        controller: controller,
        keyboardType: inputtype,
        obscureText: ispass,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hinttext,
          counterStyle:
              TextStyle(color: Colors.blue[800], fontSize: wi * 0.022),
          prefixIcon: Icon(
            icon,
            color: Colors.blue[300],
          ),
        ),
      ),
    );
  }
}

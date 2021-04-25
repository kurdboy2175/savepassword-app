import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saved_pass/dailog_box/loading_dialog.dart';
import 'package:saved_pass/screens/home_screen.dart';

import 'package:saved_pass/screens/password_view.dart';
import 'package:saved_pass/sideMenu/drawer.dart';
import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpleshScreen extends StatefulWidget {
  @override
  _SpleshScreenState createState() => _SpleshScreenState();
}

class _SpleshScreenState extends State<SpleshScreen> {
  final Future<FirebaseApp> _initializtion = Firebase.initializeApp();
  final _auth = FirebaseAuth.instance;
  // @override
  // void initState() {
  //   super.initState();
  // }
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

  startTime() async {
    if (await CheckVpnConnection.isVpnActive()) {
      var duration = Duration(seconds: 3);
      return Timer(duration, rout);
    } else {
      msg =
          " از برنامه خارج شده \n فیلتر شکن رو روشن نمایید \n دوباره وارد برنامه شوید ";
      return showTostMassege();
    }
  }

  rout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool passcode = pref.getBool("passcode");
    if (_auth.currentUser != null) {
      if (passcode) {
        return Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => PasswordView()));
      } else {
        return Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomePAge()));
      }
    } else {
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double heght = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: _initializtion,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("error : ${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("error : ${streamSnapshot.error}"),
                  ),
                );
              }
              if (streamSnapshot.connectionState == ConnectionState.active) {
                startTime();
              }
              return Scaffold(
                backgroundColor: Color(0xffeff3f6),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: width * 0.7,
                        height: heght * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          image: DecorationImage(
                            image: AssetImage("assets/images/logo_white.jpeg"),
                          ),
                        ),
                      ),
                      LoadingDialog(
                        message: "به برنامه ذخیره پسورد تیک خوش آمدید",
                      ),
                      Padding(padding: EdgeInsets.only(top: heght * 0.15)),
                      Text(
                        "ُSave PassWord TIK",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return Scaffold(
          backgroundColor: Color(0xffeff3f6),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.7,
                  height: heght * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo_white.jpeg"),
                    ),
                  ),
                ),
                LoadingDialog(
                  message: "به برنامه ذخیره پسورد تیک خوش آمدید",
                ),
                Padding(padding: EdgeInsets.only(top: heght * 0.15)),
                Text(
                  "ُSave PassWord TIK",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

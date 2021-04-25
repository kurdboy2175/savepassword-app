import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:saved_pass/screens/password_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetPasscodeScreen extends StatelessWidget {
  TextEditingController passcode = TextEditingController();
  TextEditingController reppasscode = TextEditingController();

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
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: he,
            width: wi,
            padding: EdgeInsets.only(top: wi * 0.4),
            decoration: BoxDecoration(
              color: Color(0xffeff3f6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: he * 0.015,
                ),
                textField(
                  he,
                  wi,
                  passcode,
                  TextInputType.phone,
                  true,
                  "    تعیین رمز برنامه ",
                  4,
                  Icons.lock_open,
                ),
                SizedBox(
                  height: he * 0.05,
                ),
                textField(
                  he,
                  wi,
                  reppasscode,
                  TextInputType.phone,
                  true,
                  "   تایید رمز برنامه",
                  4,
                  Icons.lock_open,
                ),
                SizedBox(
                  height: he * 0.07,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: he * 0.1,
                        width: wi * 0.4,
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
                          color: Colors.redAccent[200],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (passcode.text.isEmpty || reppasscode.text.isEmpty) {
                          msg = "هیچ رمز عبور برنامه تعیین نکرده اید!!!";
                          showTostMassege();
                          return null;
                        }
                        if (passcode.text.length < 4 ||
                            reppasscode.text.length < 4) {
                          msg =
                              "رمز عبور برنامه یا تکرار آن نباید از 4 کاراکتر کمتر باشد";
                          showTostMassege();
                          return null;
                        }
                        if (passcode.text != reppasscode.text) {
                          msg = "رمز عبور برنامه با تکرار آن همخوانی ندارد!!!";
                          showTostMassege();
                          return null;
                        }
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setString("pass", passcode.text);
                        pref.setBool("passcode", true);
                        msg =
                            " رمز عبور برنامه با موفقیت تعیین شد\n جهت اطمینان دوباره دوباره رمز عبور برنامه را وارد نمایید";
                        showTostMassege();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (c) => PasswordView()));
                      },
                      child: Container(
                        height: he * 0.1,
                        width: wi * 0.4,
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
                          Icons.lock_rounded,
                          size: wi * 0.09,
                          color: Colors.blue[200],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: he * 0.1),
                TextButton(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setBool("passcode", false);
                      pref.setString("pass", "");
                      msg = "امنیت برنامه غیر فعال شد";
                      showTostMassege();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "جهت غیر فعال کردن رمز عبور برنامه \n کلیک نمایید!!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: wi * 0.05,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
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
          // prefixIcon: Icon(
          //   icon,
          //   color: Colors.blue[300],
          // ),
        ),
      ),
    );
  }
}

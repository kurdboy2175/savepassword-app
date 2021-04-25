import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saved_pass/dailog_box/loading_dialog.dart';

class ChangePasswordScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  TextEditingController emailcont = TextEditingController();
  TextEditingController passcont = TextEditingController();
  TextEditingController newpasscont = TextEditingController();
  TextEditingController repetnewpasscont = TextEditingController();

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: he * 0.015,
            ),
            textField(
              he,
              wi,
              newpasscont,
              TextInputType.text,
              true,
              "   رمز عبور جدید",
              50,
              Icons.lock_open,
            ),
            SizedBox(
              height: he * 0.05,
            ),
            textField(
              he,
              wi,
              repetnewpasscont,
              TextInputType.text,
              true,
              "   تایید رمز عبور جدید",
              50,
              Icons.lock_open,
            ),
            SizedBox(
              height: he * 0.07,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (newpasscont.text.isEmpty ||
                        repetnewpasscont.text.isEmpty) {
                      msg = "اطلاعات خواسته شده را پر نمایید";
                      showTostMassege();
                      return null;
                    }
                    if (passcont.text.length < 6 ||
                        repetnewpasscont.text.length < 6) {
                      msg = "رمز عبور یا تکرار آن نباید از 6 کاراکتر کمتر باشد";
                      showTostMassege();
                      return null;
                    }
                    if (newpasscont.text != repetnewpasscont.text) {
                      msg = "رمز عبور با تکرار آن همخوانی ندارد!!!";
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

                      _changePassword(newpasscont.text);
                      msg = "رمز عبور شما با موفقیت تغییر یافت";
                      showTostMassege();
                      Navigator.pop(context);
                    } catch (e) {
                      msg =
                          "عملیات با خطا مواجه شد \n لطفا دورباره امتحان کنید";
                      showTostMassege();
                      Navigator.pop(context);
                    }
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
                      Icons.refresh_outlined,
                      size: wi * 0.09,
                      color: Colors.blue[200],
                    ),
                  ),
                ),
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
              ],
            ),
          ],
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
          prefixIcon: Icon(
            icon,
            color: Colors.blue[300],
          ),
        ),
      ),
    );
  }

  void _changePassword(String newpassword) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User currentUser = firebaseAuth.currentUser;
    await currentUser.updatePassword(newpassword).catchError((err) {
      msg = "عملیات با خطا مواجه شد";
      showTostMassege();
    });
  }
}

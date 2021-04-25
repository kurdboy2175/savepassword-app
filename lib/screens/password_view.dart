import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saved_pass/sideMenu/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordView extends StatefulWidget {
  @override
  _PasswordViewState createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  var indexSelect = 0;
  String code = '';

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
    var he = MediaQuery.of(context).size.height;
    var wi = MediaQuery.of(context).size.width;
    TextStyle textStyle = TextStyle(
        fontSize: wi * 0.08,
        fontWeight: FontWeight.w600,
        color: Colors.black.withBlue(40));

    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Column(
        children: [
          Container(
            height: he * 0.15,
            width: wi,
            color: Colors.blue[900],
            child: SafeArea(
              child: Container(
                height: he * 0.06,
                width: he * 0.06,
                child: Image.asset(
                  "assets/images/incognito.png",
                  color: Colors.blue[200],
                ),
              ),
            ),
          ),
          Container(
            height: he * 0.85,
            width: wi,
            decoration: BoxDecoration(
              color: Colors.blue.shade400,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(wi * 0.1),
                topRight: Radius.circular(wi * 0.1),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: wi * 0.01),
                          child: Text(
                            "جهت ورود رمز را وارد نمایید",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: wi * 0.05,
                              color: Colors.black.withBlue(100),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    color: Colors.blue[400],
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DigtalHolder(
                          index: 0,
                          wi: wi,
                          selectIndex: indexSelect,
                          code: code,
                        ),
                        DigtalHolder(
                          index: 1,
                          wi: wi,
                          selectIndex: indexSelect,
                          code: code,
                        ),
                        DigtalHolder(
                          wi: wi,
                          index: 2,
                          selectIndex: indexSelect,
                          code: code,
                        ),
                        DigtalHolder(
                          index: 3,
                          wi: wi,
                          selectIndex: indexSelect,
                          code: code,
                        ),
                      ],
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(wi * 0.1),
                          topRight: Radius.circular(wi * 0.1),
                        )),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: FlatButton(
                                    height: double.maxFinite,
                                    onPressed: () {
                                      addDigital(1);
                                    },
                                    child: Text(
                                      "1",
                                      style: textStyle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FlatButton(
                                    height: double.maxFinite,
                                    onPressed: () {
                                      addDigital(2);
                                    },
                                    child: Text(
                                      "2",
                                      style: textStyle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FlatButton(
                                    height: double.maxFinite,
                                    onPressed: () {
                                      addDigital(3);
                                    },
                                    child: Text(
                                      "3",
                                      style: textStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: FlatButton(
                                    height: double.maxFinite,
                                    onPressed: () {
                                      addDigital(4);
                                    },
                                    child: Text(
                                      "4",
                                      style: textStyle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FlatButton(
                                    height: double.maxFinite,
                                    onPressed: () {
                                      addDigital(5);
                                    },
                                    child: Text(
                                      "5",
                                      style: textStyle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FlatButton(
                                    height: double.maxFinite,
                                    onPressed: () {
                                      addDigital(6);
                                    },
                                    child: Text(
                                      "6",
                                      style: textStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: FlatButton(
                                    height: double.maxFinite,
                                    onPressed: () {
                                      addDigital(7);
                                    },
                                    child: Text(
                                      "7",
                                      style: textStyle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FlatButton(
                                    height: double.maxFinite,
                                    onPressed: () {
                                      addDigital(8);
                                    },
                                    child: Text(
                                      "8",
                                      style: textStyle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FlatButton(
                                    height: double.maxFinite,
                                    onPressed: () {
                                      addDigital(9);
                                    },
                                    child: Text(
                                      "9",
                                      style: textStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: FlatButton(
                                    height: double.maxFinite,
                                    onPressed: () {
                                      backspace();
                                    },
                                    child: Icon(
                                      Icons.backspace,
                                      size: wi * 0.1,
                                      color: Colors.black.withBlue(40),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FlatButton(
                                    height: double.maxFinite,
                                    onPressed: () {
                                      addDigital(0);
                                    },
                                    child: Text(
                                      "0",
                                      style: textStyle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FlatButton(
                                    height: double.maxFinite,
                                    onPressed: () async {
                                      SharedPreferences pref =
                                          await SharedPreferences.getInstance();

                                      String passcode =
                                          await pref.getString("pass");
                                      bool isValid = passcode == code;

                                      if (isValid) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (c) => HomePAge()));
                                      } else {
                                        setState(() {
                                          code = "";
                                          indexSelect = code.length;
                                        });
                                        msg = "رمز وارد شده استباه است";
                                        return showTostMassege();
                                      }
                                    },
                                    child: Icon(
                                      Icons.check,
                                      size: wi * 0.1,
                                      color: Colors.black.withBlue(40),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  addDigital(int digit) {
    if (code.length > 3) {
      return;
    }
    setState(() {
      code = code + digit.toString();
      print('code is $code');
      indexSelect = code.length;
    });
  }

  backspace() {
    if (code.length == 0) {
      return;
    }
    setState(() {
      code = code.substring(0, code.length - 1);
      indexSelect = code.length;
    });
  }
}

class DigtalHolder extends StatelessWidget {
  final int selectIndex;
  final int index;
  final String code;
  const DigtalHolder({
    Key key,
    @required this.wi,
    this.selectIndex,
    this.index,
    this.code,
  }) : super(key: key);

  final double wi;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: wi * 0.17,
      width: wi * 0.17,
      margin: EdgeInsets.only(right: wi * 0.04),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: index == selectIndex ? Colors.blue : Colors.transparent,
              offset: Offset(0, 0),
              spreadRadius: 1.5,
              blurRadius: 2,
            )
          ]),
      child: code.length > index
          ? Container(
              width: wi * 0.5,
              height: wi * 0.5,
              decoration: BoxDecoration(
                color: Colors.black.withBlue(40),
                shape: BoxShape.circle,
              ),
            )
          : Container(),
    );
  }
}

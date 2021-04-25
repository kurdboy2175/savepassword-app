import 'dart:io';
import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saved_pass/dailog_box/error_dailog.dart';
import 'package:saved_pass/dailog_box/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:saved_pass/sideMenu/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegestriPage extends StatefulWidget {
  @override
  _RegestriPageState createState() => _RegestriPageState();
}

class _RegestriPageState extends State<RegestriPage> {
  firebase_storage.Reference storageReferance;

  final _auth = FirebaseAuth.instance;
  TextEditingController namecont = TextEditingController();
  TextEditingController emailcont = TextEditingController();
  TextEditingController passcont = TextEditingController();
  TextEditingController repetpasscont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();

  String userImageUrl = "";
  File _imageFile;
  final picker = ImagePicker();

  Future getImagegallery() async {
    final imagePick = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (imagePick != null) {
        _imageFile = File(imagePick.path);
      } else {
        _imageFile = File("assets/images/logo_white.jpeg");
        // regesterMassege = "عکسی انتخاب نشده است";
        return null;
      }
    });
  }

  Future<void> uploudAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "لطفا عکسی انتخاب نماببد",
            );
          });
    } else {
      passcont.text.trim() == repetpasscont.text.trim()
          ? namecont.text.trim().isNotEmpty &&
                  emailcont.text.trim().isNotEmpty &&
                  passcont.text.trim().isNotEmpty &&
                  repetpasscont.text.trim().isNotEmpty
              ? upludeToStorage()
              : displayDialog("لطفا مقادیر خواسته شده را تکمیل نمایید")
          : displayDialog("رمز عبور با تکرار آن همخوانی ندارد!...");
    }
  }

  displayDialog(String msge) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: msge,
          );
        });
  }

  upludeToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(
            message: "در حال ثبت اطلاعات لطفا شکیبا باشید....",
          );
        });

    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    storageReferance =
        firebase_storage.FirebaseStorage.instance.ref().child(imageFileName);
    firebase_storage.UploadTask storageUploadTask =
        storageReferance.putFile(_imageFile);

    await storageUploadTask.then((firebase_storage.TaskSnapshot taskSnapShot) {
      taskSnapShot.ref.getDownloadURL().then((imageUrl) {
        userImageUrl = imageUrl;
        _regeterUser();
      });
    }).catchError((onError) {
      regesterMassege = onError.toString();
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: onError.toString(),
            );
          });
    });
  }

  void _regeterUser() async {
    User newUser;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: "barry.allen@example.com",
              password: "SuperSecretPassword!");
      newUser = userCredential.user;
      if (newUser != null) {
        saveUserInfoToFireStor(newUser);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        regesterMassege =
            "رمز وارد شده بسیار ضعیف میباشد. \n از رمز قویتری استفاده نمایید.";
        showTostMassege();
        return null;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        regesterMassege = "ایمیل وارد شده قبلا ثبت شده است";
        showTostMassege();
        return null;
      }
    } catch (e) {
      print(e);
      regesterMassege = "عملیات با خطا مواجه شد!";
      showTostMassege();
      return null;
    }
    // try {
    //   await _auth
    //       .createUserWithEmailAndPassword(
    //           email: emailcont.text.trim(), password: repetpasscont.text.trim())
    //       .then((auth) {
    //     newUser = auth.user;
    //   }).catchError((onError) {
    //     regesterMassege = "ایمیل وارد شده معتبر نمیباشد";
    //     showTostMassege();
    //     showDialog(
    //         context: context,
    //         builder: (c) {
    //           return ErrorDialog(
    //             message: onError.toString(),
    //           );
    //         });
    //   });

    //   if (newUser != null) {
    //     saveUserInfoToFireStor(newUser);
    //   }
    // } catch (e) {
    //   print(e.toString() + "خطایی رخ داد");
    // }
  }

  Future saveUserInfoToFireStor(User fuser) async {
    await FirebaseFirestore.instance.collection("users").doc(fuser.uid).set({
      "uid": fuser.uid,
      "emailUser": fuser.email.trim(),
      "name": namecont.text,
      "urlImage": userImageUrl,
      "phone": phoneCont.text
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('username', namecont.text);
    await pref.setString('useremail', fuser.email);
    await pref.setString('useravatar', userImageUrl);
    await pref.setString('userid', fuser.uid);
    await pref.setString(
        'phone', phoneCont.text.isEmpty ? "09123456789" : phoneCont.text);
    await pref.setString("pass", "");
    await pref.setBool("passcode", false);

    regesterMassege = "از این که ما را انتخاب کرده اید باعث افتخار ماست(._.)";
    showTostMassege();

    Route route = MaterialPageRoute(builder: (c) => HomePAge());
    Navigator.pushReplacement(context, route);
  }

  String regesterMassege = "";
  void showTostMassege() {
    Fluttertoast.showToast(
        msg: regesterMassege,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                getImagegallery();
              },
              child: CircleAvatar(
                radius: wi * 0.13,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_a_photo_outlined,
                        size: wi * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: he * 0.03,
            ),
            textField(
              he,
              wi,
              namecont,
              TextInputType.text,
              false,
              "  نام نمایشی",
              30,
              Icons.person,
            ),
            SizedBox(
              height: he * 0.03,
            ),
            textField(
              he,
              wi,
              emailcont,
              TextInputType.emailAddress,
              false,
              "   ایمیل",
              50,
              Icons.email_outlined,
            ),
            SizedBox(
              height: he * 0.03,
            ),
            textField(
              he,
              wi,
              passcont,
              TextInputType.text,
              true,
              "   رمز عبور",
              50,
              Icons.lock,
            ),
            SizedBox(
              height: he * 0.03,
            ),
            textField(
              he,
              wi,
              repetpasscont,
              TextInputType.text,
              true,
              "   تکرار رمز عبور",
              50,
              Icons.lock,
            ),
            SizedBox(
              height: he * 0.04,
            ),
            textField(
              he,
              wi,
              phoneCont,
              TextInputType.phone,
              true,
              "   شمار تلفن",
              11,
              Icons.lock,
            ),
            SizedBox(
              height: he * 0.04,
            ),
            GestureDetector(
              onTap: () async {
                if (await CheckVpnConnection.isVpnActive()) {
                  if (emailcont.text.isEmpty || passcont.text.isEmpty) {
                    regesterMassege = "اطلاعات خواسته شده را وارد نمایید";
                    showTostMassege();
                    return null;
                  }
                  if (passcont.text.length < 6 ||
                      repetpasscont.text.length < 6) {
                    regesterMassege =
                        "رمز عبور یا تکرار آن نباید از 6 کاراکتر کمتر باشد";
                    showTostMassege();
                    return null;
                  }
                  if (passcont.text != repetpasscont.text) {
                    regesterMassege = "رمز عبور با تکرار آن همخوانی ندارد!!!";
                    showTostMassege();
                    return null;
                  }
                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(emailcont.text);
                  if (!emailValid) {
                    regesterMassege = "ایمیل وارد شده معتبر نمیباشد";
                    showTostMassege();
                    return null;
                  }
                  uploudAndSaveImage();
                } else {
                  regesterMassege =
                      " از برنامه خارج شده \n فیلتر شکن رو روشن نمایید \n دوباره وارد برنامه شوید ";
                  return showTostMassege();
                }
              },
              child: Container(
                height: he * 0.09,
                width: wi * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(wi * 0.03),
                  color: Colors.grey[200],
                  //shape: BoxShape.circle,
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
                  Icons.person_add,
                  size: wi * 0.09,
                  color: Colors.blue[300],
                ),
              ),
            )
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
}

Future<void> uploudAndSaveImage() async {}

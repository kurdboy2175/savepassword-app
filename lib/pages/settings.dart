import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saved_pass/dailog_box/error_dailog.dart';
import 'package:saved_pass/dailog_box/loading_dialog.dart';
import 'package:saved_pass/screens/change_password.dart';
import 'package:saved_pass/screens/set_passcode.dart';
import 'package:saved_pass/screens/set_password.dart';
import 'package:saved_pass/screens/spleshscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _auth = FirebaseAuth.instance;

  String name = "";
  String email = "";
  String id = "";
  String imageurl = "";
  String oldimageurl = "";
  String phone = "";
  TextEditingController nameCont = TextEditingController();
  firebase_storage.Reference storageReferance;

  @override
  void initState() {
    super.initState();
    setState(() {
      reaname();
    });
  }

  Future reaname() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString('username');
    id = pref.getString('userid');
    email = pref.getString('useremail');
    oldimageurl = pref.getString('useravatar');
    phone = pref.getString('phone');
  }

  String userImageUrl = "";
  File _imageFile;
  final picker = ImagePicker();

  Future getImagegallery() async {
    final imagePick = await picker.getImage(source: ImageSource.gallery);
    setState(
      () {
        if (imagePick != null) {
          _imageFile = File(imagePick.path);
          updateImage();
        } else {
          _imageFile = File("assets/images/logo_white.jpeg");

          return null;
        }
      },
    );
  }

  Future<void> updateImage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(
            message: "در حال ثبت تغییرات لطفا شکیبا باشید",
          );
        });
    SharedPreferences pref = await SharedPreferences.getInstance();
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    storageReferance =
        firebase_storage.FirebaseStorage.instance.ref().child(imageFileName);

    firebase_storage.UploadTask storageUploadTask =
        storageReferance.putFile(_imageFile);
    await storageUploadTask.then((firebase_storage.TaskSnapshot taskSnapShot) {
      taskSnapShot.ref.getDownloadURL().then((imageUrl) {
        userImageUrl = imageUrl;
        FirebaseFirestore.instance.collection("users").doc(id).update({
          "urlImage": userImageUrl,
        });

        storageReferance = FirebaseStorage.instance.refFromURL(oldimageurl);
        storageReferance.delete();
        pref.setString('useravatar', userImageUrl);
        oldimageurl = pref.getString('useravatar');
        setState(() {});
      });
    }).catchError((onError) {
      print(onError);
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: onError.toString(),
            );
          });
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var wi = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[200],
        centerTitle: true,
        title: Text(
          "تنظیمات",
          style: TextStyle(
              color: Colors.grey[800],
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                color: Colors.blue[100],
                height: he * 0.33,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[600].withOpacity(.5),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(wi * 0.1),
                      bottomRight: Radius.circular(wi * 0.1),
                    ),
                  ),
                  child: Container(
                    height: he * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(wi * 0.2),
                        bottomRight: Radius.circular(wi * 0.2),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: he * 0.24,
                          width: wi * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(wi * 0.1),
                              bottomRight: Radius.circular(wi * 0.1),
                            ),
                          ),
                          child: oldimageurl == null
                              ? CircularProgressIndicator(
                                  backgroundColor: Colors.red,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(oldimageurl),
                                ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(),
                            Container(),
                            Container(
                              child: IconButton(
                                icon: Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.white,
                                  size: wi * 0.1,
                                ),
                                onPressed: () {
                                  getImagegallery();
                                },
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => SetPassWodPage()));
                              },
                              child: Text(
                                "امنیت",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: wi * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: he * 0.33,
              child: Container(
                height: he * 0.6,
                color: Colors.blue[100],
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[400],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(wi * 0.1),
                      topRight: Radius.circular(wi * 0.1),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: wi * 0.02),
                    child: Center(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: wi * 0.08,
                              ),
                              title: Text(
                                "نام",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: wi * 0.04,
                                ),
                              ),
                              subtitle: Text(
                                name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: wi * 0.04,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: wi * 0.06,
                                ),
                                onPressed: () {
                                  nameCont.text = name;
                                  editName(context);
                                },
                              ),
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(
                                Icons.email,
                                color: Colors.white,
                                size: wi * 0.08,
                              ),
                              title: Text(
                                "ایمیل",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: wi * 0.04,
                                ),
                              ),
                              subtitle: Text(
                                email,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: wi * 0.04,
                                ),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (c) => ChangePasswordScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue[300],
                                      borderRadius:
                                          BorderRadius.circular(wi * 0.3),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "تغییر رمز عبور",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: wi * 0.06,
                                          fontWeight: FontWeight.bold),
                                    ))),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: wi * 0.08,
                              ),
                              title: Text(
                                "تلفن",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: wi * 0.04,
                                ),
                              ),
                              subtitle: Text(
                                phone == null ? "09123456789" : phone,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: wi * 0.04,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: wi * 0.08,
                                ),
                                onPressed: () {
                                  nameCont.text = phone;
                                  editPhone(context);
                                },
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  editName(BuildContext context) {
    var wiadd = MediaQuery.of(context).size.width;
    var headd = MediaQuery.of(context).size.height;
    return showDialog(
      context: context,
      builder: (builder) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: Colors.blue[50],
            title: Text("ویرایش نام "),
            content: Container(
              height: headd * 0.13,
              width: wiadd * 0.9,
              child: Column(
                children: [
                  textField(
                    headd,
                    wiadd,
                    nameCont,
                    TextInputType.emailAddress,
                    "نام",
                    50,
                    Icons.person,
                    1,
                    false,
                  ),
                  SizedBox(
                    height: headd * 0.05,
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: headd * 0.05,
                    width: wiadd * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(wiadd * 0.03),
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
                          Colors.blue[50],
                          Colors.blue[100],
                          Colors.blue[100],
                          Colors.blue[200],
                        ],
                        stops: [.1, .3, .8, .9],
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.grading_outlined,
                        size: headd * 0.03,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        editeNametofirebase();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: headd * 0.05,
                    width: wiadd * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(wiadd * 0.03),
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
                          Colors.red[50],
                          Colors.red[100],
                          Colors.red[100],
                          Colors.red[200],
                        ],
                        stops: [.1, .3, .8, .9],
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: headd * 0.03,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        nameCont.clear();

                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  editeNametofirebase() async {
    if (nameCont.text.isEmpty) {
      return Fluttertoast.showToast(
          msg: "نام خود را وارد نمایید",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.blue[100],
          textColor: Colors.grey[700],
          fontSize: 20.0);
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({"name": nameCont.text});
    await pref.setString("username", nameCont.text);
    name = pref.getString("username");
    nameCont.clear();
    Fluttertoast.showToast(
        msg: "اطلاعات ذخیره شد!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.blue[100],
        textColor: Colors.grey[700],
        fontSize: 20.0);
    setState(() {});
    Navigator.pop(context);
  }

  editPhone(BuildContext context) {
    var wiadd = MediaQuery.of(context).size.width;
    var headd = MediaQuery.of(context).size.height;
    return showDialog(
      context: context,
      builder: (builder) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: Colors.blue[50],
            title: Text("تلفن"),
            content: Container(
              height: headd * 0.13,
              width: wiadd * 0.9,
              child: Column(
                children: [
                  textField(
                    headd,
                    wiadd,
                    nameCont,
                    TextInputType.phone,
                    "تفلن",
                    11,
                    Icons.phone_iphone_outlined,
                    1,
                    false,
                  ),
                  SizedBox(
                    height: headd * 0.05,
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: headd * 0.05,
                    width: wiadd * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(wiadd * 0.03),
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
                          Colors.blue[50],
                          Colors.blue[100],
                          Colors.blue[100],
                          Colors.blue[200],
                        ],
                        stops: [.1, .3, .8, .9],
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.grading_outlined,
                        size: headd * 0.03,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        editePhonetofirebase();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: headd * 0.05,
                    width: wiadd * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(wiadd * 0.03),
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
                          Colors.red[50],
                          Colors.red[100],
                          Colors.red[100],
                          Colors.red[200],
                        ],
                        stops: [.1, .3, .8, .9],
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: headd * 0.03,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        nameCont.clear();

                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  editePhonetofirebase() async {
    if (nameCont.text.isEmpty) {
      return Fluttertoast.showToast(
          msg: "شماره تلفن خود را وارد نمایید",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.blue[100],
          textColor: Colors.grey[700],
          fontSize: 20.0);
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({"phone": nameCont.text});
    await pref.setString("phone", nameCont.text);
    phone = pref.getString("phone");
    nameCont.clear();
    Fluttertoast.showToast(
        msg: "اطلاعات ذخیره شد!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.blue[100],
        textColor: Colors.grey[700],
        fontSize: 20.0);
    setState(() {});
    Navigator.pop(context);
  }

  Container textField(double he, double wi, controller, inputtype, hinttext,
      int max, IconData icon, int maxline, bool issubtitle) {
    return Container(
      height: issubtitle ? he * 0.3 : he * 0.08,
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
        maxLines: maxline,
        maxLength: max,
        controller: controller,
        keyboardType: inputtype,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hinttext,
          counterStyle:
              TextStyle(color: Colors.blue[800], fontSize: wi * 0.022),
          prefixIcon: Icon(
            icon,
            size: he * 0.05,
            color: Colors.blue[300],
          ),
        ),
      ),
    );
  }
}

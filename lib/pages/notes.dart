import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_swipe/drawer_swipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  TextEditingController nameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();

  String name, email;
  bool iconChange = true;

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

  var drawerKey = GlobalKey<SwipeDrawerState>();

  @override
  Widget build(BuildContext context) {
    var wi = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.blue[800],
              Colors.blue[700],
              Colors.blue[500],
              Colors.blue[400],
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.blue[700].withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(0, 1))
          ],
        ),
        child: IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.lightBlueAccent,
          ),
          onPressed: () {
            addNewPassworf(context);
          },
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[200],
        centerTitle: true,
        title: Text(
          "یادداشت",
          style: TextStyle(
              color: Colors.grey[800],
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey[800],
              Colors.grey[700],
              Colors.grey[500],
              Colors.grey[400],
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.green.withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(0, 1))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: wi * 0.9,
                  padding: EdgeInsets.only(top: he * 0.01),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(_auth.currentUser.uid)
                        .collection('user_notes')
                        .snapshots(),
                    builder: (context, orderSnapshot) {
                      return orderSnapshot.hasData
                          ? ListView.builder(
                              itemCount: orderSnapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot pass =
                                    orderSnapshot.data.docs[index];
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              index.isEven
                                                  ? Color(0xff63ffd5)
                                                  : Color(0xffffe130),
                                              index.isEven
                                                  ? Color(0xff61a3fe)
                                                  : Color(0xffffa738)
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.red.withOpacity(0.6),
                                              blurRadius: 3,
                                              spreadRadius: 1,
                                              offset: Offset(-1, -1))
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 8, bottom: 4),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "عنوان",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[50],
                                                          fontSize: wi * 0.04,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: wi * 0.1,
                                                    ),
                                                    Text(
                                                      pass['title'],
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[50],
                                                          fontSize: wi * 0.04,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 8, bottom: 4),
                                                child: InkWell(
                                                  onTap: () {
                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(_auth
                                                            .currentUser.uid)
                                                        .collection(
                                                            'user_notes')
                                                        .doc(pass.id)
                                                        .snapshots();

                                                    nameCont.text =
                                                        pass['title'];
                                                    emailCont.text =
                                                        pass['sub_title'];

                                                    updatePassword(
                                                        context, pass);
                                                  },
                                                  child: Container(
                                                    child: Text(
                                                      pass['sub_title'],
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[50],
                                                          fontSize: wi * 0.04,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.edit,
                                                        size: wi * 0.09,
                                                        color: Colors.green,
                                                      ),
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(_auth
                                                                .currentUser
                                                                .uid)
                                                            .collection(
                                                                'user_notes')
                                                            .doc(pass.id)
                                                            .snapshots();

                                                        nameCont.text =
                                                            pass['title'];
                                                        emailCont.text =
                                                            pass['sub_title'];

                                                        updatePassword(
                                                            context, pass);
                                                      }),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      size: wi * 0.09,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      deletePassword(
                                                          context, pass);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: he * 0.02,
                                    ),
                                  ],
                                );
                              },
                            )
                          : CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  updatePassword(BuildContext context, DocumentSnapshot password) {
    var wiadd = MediaQuery.of(context).size.width;
    var headd = MediaQuery.of(context).size.height;
    return showDialog(
        context: context,
        builder: (builder) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              backgroundColor: Colors.blue[50],
              title: Text("ویرایش اطلاعات "),
              content: Container(
                height: headd * 0.45,
                width: wiadd * 0.9,
                child: Column(
                  children: [
                    textField(
                        headd,
                        wiadd,
                        nameCont,
                        TextInputType.emailAddress,
                        " عنوان متن",
                        50,
                        Icons.title,
                        1,
                        false),
                    SizedBox(
                      height: headd * 0.03,
                    ),
                    textField(
                        headd,
                        wiadd,
                        emailCont,
                        TextInputType.emailAddress,
                        "متن یادداشت",
                        500,
                        Icons.subtitles,
                        10,
                        true),
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
                          updateDatatoFirebase(password);
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
                          emailCont.clear();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  deletePassword(BuildContext context, DocumentSnapshot password) {
    var wiadd = MediaQuery.of(context).size.width;
    var headd = MediaQuery.of(context).size.height;
    return showDialog(
        context: context,
        builder: (builder) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              backgroundColor: Colors.red[50],
              title: Text("حذف یادداشت انتخاب شده!!"),
              content: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.redAccent[100]),
                height: headd * 0.1,
                child: Center(
                  child: Text(
                    "آیا از حذف گزینه مورد نظر اطمینان دارید؟؟؟",
                    style: TextStyle(
                        color: Colors.redAccent[800],
                        fontSize: wiadd * 0.04,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: headd * 0.06,
                      width: wiadd * 0.25,
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
                          Icons.delete,
                          size: headd * 0.05,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(_auth.currentUser.uid)
                              .collection('user_notes')
                              .doc(password.id)
                              .delete();
                          msg = "گزینه مورد نظر با موفقیت حذف شد!!";
                          showTostMassege();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: headd * 0.06,
                      width: wiadd * 0.25,
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
                          Icons.arrow_forward_ios,
                          size: headd * 0.05,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  addNewPassworf(BuildContext context) {
    var wiadd = MediaQuery.of(context).size.width;
    var headd = MediaQuery.of(context).size.height;
    return showDialog(
        context: context,
        builder: (builder) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              backgroundColor: Colors.blue[50],
              title: Text("ثبت یادداشت جدید"),
              content: Container(
                height: headd * 0.45,
                child: Column(
                  children: [
                    textField(
                        headd,
                        wiadd,
                        nameCont,
                        TextInputType.emailAddress,
                        "عنوان",
                        50,
                        Icons.title,
                        1,
                        false),
                    SizedBox(
                      height: headd * 0.04,
                    ),
                    textField(
                        headd,
                        wiadd,
                        emailCont,
                        TextInputType.emailAddress,
                        "متن",
                        500,
                        Icons.subtitles,
                        10,
                        true),
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
                          saveDatatoFirebase();
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
                          emailCont.clear();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
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

  saveDatatoFirebase() async {
    // final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    if (nameCont.text.isEmpty || emailCont.text.isEmpty) {
      msg = "مقادیر را وارد نمایید!!!!";
      return showTostMassege();
    }
    CollectionReference userPassword = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("user_notes");
    await userPassword.add({
      "title": nameCont.text,
      "sub_title": emailCont.text,
    });
    msg = "اطلاعات با موفقیت ثبت گردید!!!!!";
    showTostMassege();
    nameCont.clear();
    emailCont.clear();
    Navigator.pop(context);
  }

  updateDatatoFirebase(DocumentSnapshot passwword) async {
    final user = _auth.currentUser;
    CollectionReference userPassword = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("user_notes");
    userPassword.doc(passwword.id).update({
      "title": nameCont.text,
      "sub_title": emailCont.text,
    });
    msg = "اطلاعات با موفقیت ویرایش شد!!!";
    showTostMassege();
    nameCont.clear();
    emailCont.clear();
    Navigator.pop(context);
  }
}

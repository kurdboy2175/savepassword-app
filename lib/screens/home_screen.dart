import 'package:flutter/material.dart';
import 'package:saved_pass/screens/login.dart';
import 'package:saved_pass/screens/regestri.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSignPage = true;
  @override
  Widget build(BuildContext context) {
    var wi = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffb6eeff),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeInOutCubic,
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: he * 0.35,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/logo_white.jpeg"),
                      fit: BoxFit.fill),
                ),
                child: Container(
                  padding: EdgeInsets.only(top: wi * 0.10, right: wi * 0.05),
                  color: Color(0xffb6eeff).withOpacity(.75),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "خوش آمدید ",
                          style: TextStyle(
                              letterSpacing: 2,
                              color: Color(0xff191970),
                              fontSize: wi * 0.06),
                          children: [
                            TextSpan(
                              text: isSignPage ? " ذخیره پسورد تیک" : " ",
                              style: TextStyle(
                                  color: Color(0xff191970),
                                  fontSize: wi * 0.07,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: he * 0.005,
                      ),
                      Text(
                        isSignPage
                            ? "جهت ورود به برنامه ثبت نام کنید"
                            : "جهت ورود مشخصات خود را وارد نمایید",
                        style: TextStyle(
                            color: Color(0xffff7438),
                            letterSpacing: 1,
                            fontSize: wi * 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeInOutCubic,
              top: he * 0.18,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: wi * 0.03),
                margin: EdgeInsets.symmetric(horizontal: wi * 0.05),
                decoration: BoxDecoration(
                    color: Color(0xffeff3f6).withOpacity(.3),
                    borderRadius: BorderRadius.circular(wi * 0.02)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSignPage = false;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            width: wi * 0.41,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffeff3f6)
                                    .withOpacity(!isSignPage ? 0.9 : 0.4)),
                            child: Center(
                              child: Text(
                                "ورود",
                                style: TextStyle(
                                    color: !isSignPage
                                        ? Color(0xff084845)
                                        : Color(0xff4ac7ee),
                                    fontSize: wi * 0.05,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          if (!isSignPage)
                            Container(
                              margin: EdgeInsets.only(top: he * 0.003),
                              height: he * 0.003,
                              width: wi * 0.15,
                              color: Color(0xffb6eeff),
                            )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSignPage = true;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            width: wi * 0.41,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffeff3f6)
                                    .withOpacity(isSignPage ? 0.9 : 0.4)),
                            child: Center(
                              child: Text(
                                "ثبت نام",
                                style: TextStyle(
                                    color: isSignPage
                                        ? Color(0xff081845)
                                        : Color(0xff4ac7ee),
                                    fontSize: wi * 0.05,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          if (isSignPage)
                            Container(
                              margin: EdgeInsets.only(top: he * 0.003),
                              height: he * 0.003,
                              width: wi * 0.15,
                              color: Color(0xffb6eeff),
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeInOutCubic,
              top: he * 0.22,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                curve: Curves.bounceOut,
                height: isSignPage ? he * 0.75 : he * 0.55,
                padding: EdgeInsets.all(wi * 0.05),
                margin: EdgeInsets.symmetric(horizontal: wi * 0.05),
                decoration: BoxDecoration(
                  color: Color(0xffeff3f6),
                  borderRadius: BorderRadius.circular(wi * 0.03),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5)
                  ],
                ),
                child: SingleChildScrollView(
                  physics: !isSignPage ? NeverScrollableScrollPhysics() : null,
                  child: Column(
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //       color: Color(0xffb6eeff).withOpacity(.3),
                      //       borderRadius: BorderRadius.circular(wi * 0.02)),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       GestureDetector(
                      //         onTap: () {
                      //           setState(() {
                      //             isSignPage = false;
                      //           });
                      //         },
                      //         child: Column(
                      //           children: [
                      //             Text(
                      //               "ورود",
                      //               style: TextStyle(
                      //                   color: !isSignPage
                      //                       ? Color(0xff084845)
                      //                       : Color(0xff4ac7ee),
                      //                   fontSize: wi * 0.05,
                      //                   fontWeight: FontWeight.bold),
                      //             ),
                      //             if (!isSignPage)
                      //               Container(
                      //                 margin: EdgeInsets.only(top: he * 0.003),
                      //                 height: he * 0.003,
                      //                 width: wi * 0.15,
                      //                 color: Color(0xffb6eeff),
                      //               )
                      //           ],
                      //         ),
                      //       ),
                      //       GestureDetector(
                      //         onTap: () {
                      //           setState(() {
                      //             isSignPage = true;
                      //           });
                      //         },
                      //         child: Column(
                      //           children: [
                      //             Text(
                      //               "ثبت نام",
                      //               style: TextStyle(
                      //                   color: isSignPage
                      //                       ? Color(0xff081845)
                      //                       : Color(0xff4ac7ee),
                      //                   fontSize: wi * 0.05,
                      //                   fontWeight: FontWeight.bold),
                      //             ),
                      //             if (isSignPage)
                      //               Container(
                      //                 margin: EdgeInsets.only(top: he * 0.003),
                      //                 height: he * 0.003,
                      //                 width: wi * 0.15,
                      //                 color: Color(0xffb6eeff),
                      //               )
                      //           ],
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      SizedBox(
                        height: he * 0.03,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.easeInOutCubic,
                        height: he,
                        width: wi,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(wi * 0.03)),
                        child: isSignPage ? RegestriPage() : LoginPage(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

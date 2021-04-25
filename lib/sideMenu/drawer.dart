import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saved_pass/pages/Home.dart';
import 'package:saved_pass/pages/notes.dart';
import 'package:saved_pass/pages/settings.dart';
import 'package:saved_pass/sideMenu/bottom_tab.dart';

class HomePAge extends StatefulWidget {
  @override
  _HomePAgeState createState() => _HomePAgeState();
}

class _HomePAgeState extends State<HomePAge> {
  //FirebaseServices _firebaseServices = FirebaseServices();

  PageController _tabPageController;
  int _selectedTab = 0;

  @override
  void initState() {
    // print("user id:${_firebaseServices.getUSerId()}");
    _tabPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: PageView(
              controller: _tabPageController,
              onPageChanged: (num) {
                setState(() {
                  _selectedTab = num;
                });
              },
              children: [
                Home(),
                Notes(),
                Settings(),
              ],
            ),
          ),
          BottomTab(
            selectedTab: _selectedTab,
            tabPress: (num) {
              _tabPageController.animateToPage(num,
                  duration: Duration(milliseconds: 300), curve: Curves.easeOut);
            },
          )
        ],
      ),
    );
  }
}

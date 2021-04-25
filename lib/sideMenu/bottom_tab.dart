import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saved_pass/screens/spleshscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomTab extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPress;

  BottomTab({this.selectedTab, this.tabPress});

  @override
  _BottomTabState createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    _selectedTab = widget.selectedTab ?? 0;
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue[200],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 30)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabBtn(
            imagePath: "assets/images/home.png",
            selected: _selectedTab == 0 ? true : false,
            onPressed: () {
              widget.tabPress(0);
            },
          ),
          BottomTabBtn(
              imagePath: "assets/images/notes.png",
              selected: _selectedTab == 1 ? true : false,
              onPressed: () {
                widget.tabPress(1);
              }),
          BottomTabBtn(
              imagePath: "assets/images/setting.png",
              selected: _selectedTab == 2 ? true : false,
              onPressed: () {
                widget.tabPress(2);
              }),
          BottomTabBtn(
            imagePath: "assets/images/logout.png",
            selected: _selectedTab == 3 ? true : false,
            onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setBool("passcode", false);
              pref.setString("pass", "");

              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (c) => SpleshScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class BottomTabBtn extends StatelessWidget {
  final String imagePath;
  final IconData icon;
  final bool selected;
  final Function onPressed;

  BottomTabBtn({this.imagePath, this.selected, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 28),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: _selected
                        ? Theme.of(context).accentColor
                        : Colors.transparent,
                    width: 2))),
        child: Image(
          image: AssetImage(imagePath ?? "assets/images/tab_home.png"),
          width: 22,
          height: 22,
          color: _selected ? Theme.of(context).accentColor : Colors.black,
        ),
      ),
    );
  }
}

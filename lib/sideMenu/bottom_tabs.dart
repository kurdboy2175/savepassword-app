import 'package:flutter/material.dart';

class BottomTabs extends StatelessWidget {
  int _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 30)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabBtn(
            imagePath: "assets/images/home.png",
            selected: _selectedTab == 0 ? true : false,
          ),
          BottomTabBtn(
            imagePath: "assets/images/notes.png",
            selected: _selectedTab == 1 ? true : false,
          ),
          BottomTabBtn(
            imagePath: "assets/images/setting.png",
            selected: _selectedTab == 2 ? true : false,
          ),
          BottomTabBtn(
            imagePath: "assets/images/logout.png",
            selected: _selectedTab == 3 ? true : false,
          ),
        ],
      ),
    );
  }
}

class BottomTabBtn extends StatelessWidget {
  final String imagePath;
  final bool selected;
  final IconData icon;

  BottomTabBtn({this.imagePath, this.selected, this.icon});

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: _selected
                      ? Theme.of(context).accentColor
                      : Colors.transparent,
                  width: 2))),
      child: Image(
        image: AssetImage(
          imagePath ?? "assets/images/home.png",
        ),
        width: 22,
        height: 22,
        color: _selected ? Theme.of(context).accentColor : Colors.black,
      ),
    );
  }
}
